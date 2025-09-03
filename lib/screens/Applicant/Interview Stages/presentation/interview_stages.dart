import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/constants/status.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/models/userModel.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
import 'package:rooster_empployee/service/apiService.dart';
import 'package:rooster_empployee/service/apiUrls.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/utils/documentUploadDialoge.dart';
import 'package:rooster_empployee/utils/drawer_applicant.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';
import 'package:rooster_empployee/utils/webView.dart';
import 'package:url_launcher/url_launcher.dart';

class InterviewDashboardPage extends StatefulWidget {
  const InterviewDashboardPage({Key? key}) : super(key: key);

  @override
  State<InterviewDashboardPage> createState() => _InterviewDashboardPageState();
}

class _InterviewDashboardPageState extends State<InterviewDashboardPage> {
  late Future<CandidateResponse?> _futureData;
  List<bool> _expandedStates = [];
  bool _showFullJobDesc = false;

  @override
  void initState() {
    super.initState();
    _futureData = loadJsonData();
  }

  Future<void> _openUploadDialog({
    required String id,
    required bool isOffer,
  }) async {
    final shouldRefresh = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // prevents outside-tap from returning null
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: BlocProvider.value(
            value: context.read<UploadBloc>(),
            child: SingleDocumentUploadDialogContent(
              assessmentId: id,
              isOffer: isOffer,
            ),
          ),
        ),
      ),
    );

    if (!mounted) return;
    if (shouldRefresh == true) {
      setState(() => _futureData = loadJsonData());
    }
  }

  Future<CandidateResponse?> loadJsonData() async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final stringUserData = await FlutterSecureData.getUserData();
      debugPrint('User Data: $stringUserData', wrapWidth: 1024);

      final response = await ApiService(Dio()).getCandiate();
      final data = CandidateResponse.fromJson(response);

      // Initialize expanded states ONCE here
      final jobApplications = data.data.jobs;
      if (jobApplications.isNotEmpty) {
        // Sort stages by jobStageOrder before creating expanded states
        final sortedStages = [...jobApplications.first.stages]
          ..sort((a, b) => a.jobStageOrder!.compareTo(b.jobStageOrder!));
        _expandedStates = List.filled(sortedStages.length, false);
      }

      return data;
    } catch (e) {
      debugPrint('Error loading candidate data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      drawer: const DrawerWidgetApplicant(),
      body: FutureBuilder<CandidateResponse?>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load data."));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No interview data found."));
          }

          final candidate = snapshot.data!.data.candidate;
          final jobApplications = snapshot.data!.data.jobs;

          if (jobApplications.isEmpty) {
            return const Center(child: Text("No job applications found."));
          }

          final job = jobApplications.first.job;
          final stages = jobApplications.first.stages;

          final currentStep = getCurrentStepIndex(stages);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildUserCard(candidate, media),
                const SizedBox(height: 16),
                buildJobAndStagesCard(
                  job ?? Job(),
                  stages,
                  currentStep,
                  media,
                  jobApplications,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --------------------------
  // Premium UI — USER CARD
  // --------------------------
  Widget buildUserCard(Candidate candidate, Size media) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: media.width * 0.09,
              backgroundColor: AppColors.primary,
              child: Text(
                '${candidate.firstName[0]}${candidate.lastName[0]}'
                    .toUpperCase(),
                style: AppTextStyles.headline2.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${candidate.firstName} ${candidate.lastName}',
                    style: AppTextStyles.headline2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _infoLine(
                      icon: Icons.alternate_email, label: candidate.email),
                  _infoLine(
                      icon: Icons.home_outlined, label: candidate.address),
                  _infoLine(icon: Icons.phone_rounded, label: candidate.phone),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoLine({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------
  // Premium UI — JOB & STAGES CARD
  // --------------------------------------
  Widget buildJobAndStagesCard(
    Job job,
    List<Stage> stages,
    int currentStep,
    Size media,
    List<JobApplication> jobApplications,
  ) {
    final sortedStages = [...stages]
      ..sort((a, b) => a.jobStageOrder!.compareTo(b.jobStageOrder!));

    return Card(
      elevation: 2,
      shadowColor: AppColors.border,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title ?? '',
                style: AppTextStyles.headline2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),

            // Job Description Toggle
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _showFullJobDesc = !_showFullJobDesc),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Description', style: AppTextStyles.bodyLarge),
                  const SizedBox(width: 6),
                  Icon(
                    _showFullJobDesc ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.icon,
                  )
                ],
              ),
            ),
            AnimatedCrossFade(
              crossFadeState: _showFullJobDesc
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  job.description ?? '',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text('📌 Hiring Stages', style: AppTextStyles.headline4),
            const SizedBox(height: 12),

            ...List.generate(sortedStages.length, (index) {
              return buildCustomExpandableStageCard(
                sortedStages[index],
                index,
                currentStep,
                index != sortedStages.length - 1,
                media,
                jobApplications.first.interviews,
              );
            }),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------
  // Premium UI — EXPANDABLE STAGE ITEM (timeline feel)
  // -------------------------------------------------
  Widget buildCustomExpandableStageCard(
    Stage stage,
    int index,
    int currentStep,
    bool showLine,
    Size media,
    List<Interview> interviews,
  ) {
    final bool expanded = _expandedStates[index];

    final visuals = _getStageVisuals(stage);

    final bool isUpcoming = stage.statusName == CndidateStageStatus.upcoming ||
        stage.jobStageOrder! > currentStep;

    return GestureDetector(
      onTap: () {
        if (!isUpcoming) {
          setState(() => _expandedStates[index] = !_expandedStates[index]);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(left: 40, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Content Card
            Card(
              elevation: 1.5,
              shadowColor: AppColors.border,
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(visuals.icon, color: visuals.iconColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            stage.hiringStageName ?? '',
                            style: AppTextStyles.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isUpcoming)
                          Icon(
                            expanded ? Icons.expand_less : Icons.expand_more,
                            color: AppColors.icon,
                          ),
                      ],
                    ),
                    if (expanded) ...[
                      const SizedBox(height: 10),
                      buildStageDetails(stage, interviews),
                    ],
                  ],
                ),
              ),
            ),

            // Timeline Dot + Connector
            Positioned(
              top: 16,
              left: -40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: visuals.circleColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: visuals.circleColor.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(child: visuals.circleChild),
                  ),
                  if (showLine)
                    SizedBox(
                      height: expanded ? 160 : 40,
                      child: CustomPaint(
                        painter: DottedLinePainter(
                          height: expanded ? 160 : 40,
                          color: visuals.iconColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStageDetails(Stage stage, List<Interview> interviews) {
    final visuals = _getStageVisuals(stage);
    print('the interviews are ${interviews.length}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          visuals.statusText,
          style: AppTextStyles.headline4.copyWith(color: visuals.iconColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        if ((stage.hiringStageDescription ?? '').isNotEmpty)
          Text(
            stage.hiringStageDescription ?? '',
            style: AppTextStyles.bodySmall,
          ),
        if (stage.statusName == CndidateStageStatus.rejected ||
            stage.statusName == CndidateStageStatus.withdrawn) ...[
          const SizedBox(height: 8),
          Text(
            'Reason: Not specified',
            style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 12),

        // Interviews
        if (stage.statusName != CndidateStageStatus.completed &&
            stage.statusName != CndidateStageStatus.hired &&
            stage.statusName != CndidateStageStatus.selected &&
            stage.statusName != CndidateStageStatus.rejected) ...[
          _buildInterviewDetails(stage, interviews),
          const SizedBox(height: 12),
        ],

        // Assessments
        if (stage.statusName != CndidateStageStatus.completed &&
            stage.statusName != CndidateStageStatus.hired &&
            stage.statusName != CndidateStageStatus.selected &&
            stage.statusName != CndidateStageStatus.rejected) ...[
          if (stage.assessments.isNotEmpty)
            ...stage.assessments.map((a) => buildAssessmentDetails(a)).toList(),
        ],

        // Offer Letter
        if (stage.hiringStageName == 'Offer Letter' &&
            stage.statusName != CndidateStageStatus.completed &&
            stage.statusName != CndidateStageStatus.hired &&
            stage.statusName != CndidateStageStatus.selected &&
            stage.statusName != CndidateStageStatus.rejected) ...[
          if (stage.offerLetters.isNotEmpty &&
              stage.offerLetters.first.id != null)
            buildOfferLetterDetails(stage.offerLetters.first, stage),
        ],
      ],
    );
  }

  Widget buildOfferLetterDetails(OfferLetter offerLetter, Stage stage) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Offer Letter', style: AppTextStyles.headline3),
            const SizedBox(height: 8),
            if (offerLetter.offerLetterFile != null &&
                (offerLetter.offerLetterFile!.name ?? '').isNotEmpty &&
                (offerLetter.offerLetterFile!.path ?? '').isNotEmpty)
              _smallButton(
                icon: Icons.file_download,
                label: 'Download Offer Letter',
                onPressed: () =>
                    _downloadTaskFile(offerLetter.offerLetterFile!.path!),
              ),
            if (offerLetter.acceptedLetterFile == null ||
                offerLetter.acceptedLetterFile!.path == null)
              _smallButton(
                icon: Icons.upload_file,
                label: 'Upload Offer Letter',
                onPressed: () async {
                  await _openUploadDialog(
                    id: offerLetter.id ?? '',
                    isOffer: true,
                  );

                  // showDialog(
                  //   context: context,
                  //   builder: (_) => AlertDialog(
                  //     backgroundColor: Colors.transparent,
                  //     insetPadding: const EdgeInsets.symmetric(
                  //         horizontal: 16, vertical: 24),
                  //     contentPadding: EdgeInsets.zero,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16)),
                  //     content: SizedBox(
                  //       width: MediaQuery.of(context).size.width * 0.9,
                  //       height: MediaQuery.of(context).size.height * 0.6,
                  //       child: BlocProvider.value(
                  //         value: context.read<UploadBloc>(),
                  //         child: SingleDocumentUploadDialogContent(
                  //           assessmentId: offerLetter.id ?? '',
                  //           isOffer: true,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                  // setState(() => _futureData = loadJsonData());
                },
              ),
            if (offerLetter.acceptedLetterFile != null &&
                offerLetter.acceptedLetterFile!.path != null)
              _smallButton(
                icon: Icons.remove_red_eye_outlined,
                label: 'Submitted Offer Letter',
                onPressed: () {
                  if (Platform.isAndroid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InAppWebViewPage(
                          url:
                              'https://docs.google.com/gview?embedded=1&url=${ApiUrl.imageUrl}${offerLetter.acceptedLetterFile!.path}',
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InAppWebViewPage(
                          url:
                              '${ApiUrl.imageUrl}${offerLetter.acceptedLetterFile!.path}',
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAssessmentDetails(Assessment assessment) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(assessment.title ?? '',
                style: AppTextStyles.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            // if ((assessment.description ?? '').isNotEmpty)
            Text('Task: ${assessment.description}',
                style: AppTextStyles.bodySmall),
            if ((assessment.taskFileId ?? '').isNotEmpty)
              _smallButton(
                icon: Icons.file_download,
                label: 'Download Task File',
                onPressed: () => _downloadTaskFile(assessment.taskFile!.path!),
              ),
            if (assessment.submittedFile == null ||
                (assessment.submittedFile!.path ?? '').isEmpty)
              _smallButton(
                icon: Icons.upload_file,
                label: 'Upload Task File',
                onPressed: () async {
                  await _openUploadDialog(
                    id: assessment.id ?? '',
                    isOffer: false,
                  );
                  // showDialog(
                  //   context: context,
                  //   builder: (_) => AlertDialog(
                  //     backgroundColor: Colors.transparent,
                  //     insetPadding: const EdgeInsets.symmetric(
                  //         horizontal: 16, vertical: 24),
                  //     contentPadding: EdgeInsets.zero,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16)),
                  //     content: SizedBox(
                  //       width: MediaQuery.of(context).size.width * 0.9,
                  //       height: MediaQuery.of(context).size.height * 0.6,
                  //       child: BlocProvider.value(
                  //         value: context.read<UploadBloc>(),
                  //         child: SingleDocumentUploadDialogContent(
                  //           assessmentId: assessment.id ?? '',
                  //           isOffer: false,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                  // setState(() => _futureData = loadJsonData());
                },
              ),
            if (assessment.submittedFile != null &&
                (assessment.submittedFile!.path ?? '').isNotEmpty)
              _smallButton(
                icon: Icons.remove_red_eye_outlined,
                label: 'View Submitted File',
                onPressed: () {
                  if (Platform.isAndroid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InAppWebViewPage(
                          url:
                              'https://docs.google.com/gview?embedded=1&url=${ApiUrl.imageUrl}${assessment.submittedFile!.path}',
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InAppWebViewPage(
                          url:
                              '${ApiUrl.imageUrl}${assessment.submittedFile!.path}',
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _smallButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 44,
        child: ElevatedButton.icon(
          icon: Icon(icon, color: Colors.white, size: 18),
          onPressed: onPressed,
          label:
              Text(label, style: AppTextStyles.button.copyWith(fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadTaskFile(String fileId) async {
    final uri = Uri.parse('${ApiUrl.imageUrl}$fileId');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ToastMessage.showMessage('Could not launch file.');
    }
  }

  Widget _buildInterviewDetails(Stage stage, List<Interview> interviews) {
    final matchingInterviews = stage.interviews;
    // interviews.where((i) => i.jobStageId == stage.jobStageId).toList();
    print('Matching interviews for stage ${stage.hiringStageName}: '
        '${matchingInterviews.length}');

    if (matchingInterviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Interviews', style: AppTextStyles.headline3),
        const SizedBox(height: 8),
        ...matchingInterviews.map((interview) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: AppColors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _iconText(Icons.event,
                        formatInterviewDate(interview.scheduledAt ?? '')),
                    _iconText(Icons.flag_outlined,
                        'Round: ${interview.roundName ?? '-'}'),
                    if ((interview.roundDescription ?? '').isNotEmpty)
                      _iconText(
                          Icons.notes_outlined, interview.roundDescription!),
                    _iconText(Icons.forum_outlined,
                        'Mode: ${(interview.interviewMode ?? '').toUpperCase()}'),
                    if ((interview.remarks ?? '').isNotEmpty)
                      _iconText(Icons.chat_bubble_outline,
                          'Remarks: ${interview.remarks}'),
                    const SizedBox(height: 8),
                    if (interview.interviewMode == 'virtual')
                      _smallButton(
                        icon: Icons.video_call,
                        label: 'Join Meeting',
                        onPressed: () =>
                            launchUrl(Uri.parse(interview.meetingLink!)),
                      ),
                    if (interview.interviewMode == 'physical')
                      _smallButton(
                        icon: Icons.location_on,
                        label: 'View Location',
                        onPressed: () => launchUrl(
                          Uri.parse(
                              'https://maps.google.com/?q=Interview+Location'),
                        ),
                      ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }

  int getCurrentStepIndex(List<Stage> stages) {
    final sortedStages = [...stages]
      ..sort((a, b) => a.jobStageOrder!.compareTo(b.jobStageOrder!));

    for (int i = 0; i < sortedStages.length; i++) {
      if (sortedStages[i].statusName == CndidateStageStatus.inProgress) {
        return i;
      }
    }
    return sortedStages.length - 1;
  }
}

// -----------------------------
// DOTTED LINE PAINTER
// -----------------------------
class DottedLinePainter extends CustomPainter {
  final double height;
  final Color color;

  DottedLinePainter({required this.height, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double dashHeight = 4;
    const double dashSpace = 4;
    double startY = 0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    while (startY < height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DottedLinePainter oldDelegate) {
    return oldDelegate.height != height || oldDelegate.color != color;
  }
}

String formatInterviewDate(String dateTimeStr) {
  try {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('yyyy MMM dd').format(dateTime);
  } catch (_) {
    return dateTimeStr;
  }
}

class _StageVisuals {
  final Color circleColor;
  final Color iconColor;
  final IconData icon;
  final Color lineColor;
  final Widget circleChild;
  final String statusText;
  final Color textColor;

  _StageVisuals({
    required this.circleColor,
    required this.iconColor,
    required this.icon,
    required this.lineColor,
    required this.circleChild,
    required this.statusText,
    required this.textColor,
  });
}

_StageVisuals _getStageVisuals(Stage stage) {
  switch (stage.statusName) {
    case CndidateStageStatus.hired:
      return _StageVisuals(
        circleColor: AppColors.success,
        iconColor: AppColors.success,
        icon: Icons.work_outline,
        lineColor: AppColors.divider,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Hired',
        textColor: Colors.white,
      );
    case CndidateStageStatus.selected:
      return _StageVisuals(
        circleColor: AppColors.success,
        iconColor: AppColors.success,
        icon: Icons.check_circle_outline,
        lineColor: AppColors.divider,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Selected',
        textColor: Colors.white,
      );
    case CndidateStageStatus.completed:
      return _StageVisuals(
        circleColor: AppColors.success,
        iconColor: AppColors.success,
        icon: Icons.check_circle_outline,
        lineColor: AppColors.divider,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Completed',
        textColor: Colors.white,
      );
    case CndidateStageStatus.rejected:
      return _StageVisuals(
        circleColor: AppColors.error,
        iconColor: AppColors.error,
        icon: Icons.cancel_outlined,
        lineColor: AppColors.divider,
        circleChild: const Icon(Icons.close, size: 16, color: Colors.white),
        statusText: 'Rejected',
        textColor: Colors.white,
      );
    case CndidateStageStatus.withdrawn:
      return _StageVisuals(
        circleColor: AppColors.border,
        iconColor: AppColors.border,
        icon: Icons.exit_to_app,
        lineColor: AppColors.divider,
        circleChild: const Icon(Icons.close, size: 16, color: Colors.white),
        statusText: 'Withdrawn',
        textColor: AppColors.textPrimary,
      );
    case CndidateStageStatus.inProgress:
    case CndidateStageStatus.in_Progress:
      return _StageVisuals(
        circleColor: AppColors.inProgress,
        iconColor: AppColors.inProgress,
        icon: Icons.hourglass_top_rounded,
        lineColor: AppColors.divider,
        circleChild: Text(
          '${stage.jobStageOrder! + 1}',
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        statusText: 'In Progress',
        textColor: Colors.white,
      );
    case CndidateStageStatus.reviewed:
      return _StageVisuals(
        circleColor: Colors.purple,
        iconColor: Colors.purple,
        icon: Icons.rate_review_outlined,
        lineColor: AppColors.divider,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Reviewed',
        textColor: Colors.white,
      );
    case CndidateStageStatus.upcoming:
    default:
      return _StageVisuals(
        circleColor: AppColors.divider,
        iconColor: AppColors.warning,
        icon: Icons.access_time,
        lineColor: AppColors.divider,
        circleChild: Text(
          '${stage.jobStageOrder! + 1}',
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        statusText: 'Upcoming',
        textColor: AppColors.textPrimary,
      );
  }
}
