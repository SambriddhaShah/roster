import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/constants/status.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/models/userModel.dart';
import 'package:rooster_empployee/service/apiService.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/utils/drawer_applicant.dart';
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
          ..sort((a, b) => a.jobStageOrder.compareTo(b.jobStageOrder));
        _expandedStates = List.filled(sortedStages.length, false);
      }

      return data;
    } catch (e) {
      print('Error loading candidate data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: DrawerWidgetApplicant(),
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
              children: [
                buildUserCard(candidate, media),
                buildJobAndStagesCard(
                    job, stages, currentStep, media, jobApplications),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildUserCard(Candidate candidate, Size media) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          children: [
            CircleAvatar(
              radius: media.width * 0.08,
              backgroundColor: AppColors.primary,
              child: Text(
                '${candidate.firstName[0]}${candidate.lastName[0]}'
                    .toUpperCase(),
                style: TextStyle(
                  fontSize: media.width * 0.07,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${candidate.firstName} ${candidate.lastName}',
                      style: TextStyle(
                          fontSize: media.width * 0.06,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    '📧 ${candidate.email}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '🏠 ${candidate.address}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '📱 ${candidate.phone}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJobAndStagesCard(
    Job job,
    List<Stage> stages,
    int currentStep,
    Size media,
    List<JobApplication> jobApplications,
  ) {
    // Sort stages by jobStageOrder before displaying
    final sortedStages = [...stages]
      ..sort((a, b) => a.jobStageOrder.compareTo(b.jobStageOrder));

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: TextStyle(
                fontSize: media.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                setState(() => _showFullJobDesc = !_showFullJobDesc);
              },
              child: Row(
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _showFullJobDesc
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24,
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              crossFadeState: _showFullJobDesc
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(job.description),
              ),
            ),
            const SizedBox(height: 20),
            Text("📌 Hiring Stages",
                style: TextStyle(
                    fontSize: media.width * 0.045,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
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

  Widget buildCustomExpandableStageCard(
    Stage stage,
    int index,
    int currentStep,
    bool showLine,
    Size media,
    List<Interview> interviews,
  ) {
    bool expanded = _expandedStates[index];

    // Status determination
    bool isCompleted = stage.statusName == CndidateStageStatus.selected ||
            stage.statusName == CndidateStageStatus.hired ||
            CndidateStageStatus.completed == stage.statusName
        // ||
        // stage.jobStageOrder < currentStep
        ;
    final visuals = _getStageVisuals(stage);

    bool isCurrent = stage.statusName == CndidateStageStatus.inProgress
        // ||
        //     stage.jobStageOrder == currentStep
        ;

    bool isUpcoming = stage.statusName == CndidateStageStatus.upcoming ||
        stage.jobStageOrder > currentStep;

    bool isRejected = stage.statusName == CndidateStageStatus.rejected;

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedStates[index] = !_expandedStates[index];
        });
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 40),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            visuals.icon,
                            // isRejected
                            //     ? Icons.cancel_outlined
                            //     : isCompleted
                            //         ? Icons.check_circle_outline
                            //         : isCurrent
                            //             ? Icons.hourglass_top_rounded
                            //             : Icons.access_time,
                            color: visuals.iconColor,
                            // isRejected
                            //     ? Colors.red
                            //     : isCompleted
                            //         ? Colors.green
                            //         : isCurrent
                            //             ? Colors.blue
                            //             : Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              stage.hiringStageName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          Icon(
                            expanded ? Icons.expand_less : Icons.expand_more,
                          ),
                        ],
                      ),
                      if (expanded) ...[
                        const SizedBox(height: 10),
                        buildStageDetails(stage, interviews),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 27,
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: visuals.circleColor
                    // isRejected
                    //     ? Colors.red
                    //     : isCompleted
                    //         ? Colors.green
                    //         : isCurrent
                    //             ? Colors.blue
                    //             : Colors.grey.shade300
                    ,
                    child: isRejected
                        ? const Icon(Icons.close, size: 16, color: Colors.white)
                        : isCompleted
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: visuals.textColor
                                  // isCurrent ? Colors.white : Colors.black
                                  ,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                  if (showLine)
                    SizedBox(
                      height: expanded ? 160 : 40,
                      child: CustomPaint(
                        painter: DottedLinePainter(
                          height: expanded ? 160 : 40,
                          color: visuals.iconColor
                          // isCompleted ? Colors.green : Colors.grey.shade400
                          ,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(visuals.statusText,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: visuals.iconColor)),
        const SizedBox(height: 8),
        Text("📝 ${stage.hiringStageDescription}"),
        if (stage.statusName == CndidateStageStatus.rejected ||
            stage.statusName == CndidateStageStatus.withdrawn)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text("💬 Reason: ${'Not specified'}",
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ),
        const SizedBox(height: 12),
        _buildInterviewDetails(stage, interviews),
      ],
    );
  }

  Widget _buildInterviewDetails(Stage stage, List<Interview> interviews) {
    final matchingInterviews =
        interviews.where((i) => i.jobStageId == stage.jobStageId).toList();

    if (matchingInterviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🎯 Interviews:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...matchingInterviews.map((interview) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("🗓 ${formatInterviewDate(interview.scheduledAt)}"),
                    Text("📛 Round: ${interview.roundName}"),
                    if (interview.roundDescription?.isNotEmpty ?? false)
                      Text("📋 ${interview.roundDescription!}"),
                    Text("🧩 Mode: ${interview.interviewMode.toUpperCase()}"),
                    if (interview.remarks?.isNotEmpty ?? false)
                      Text("💬 Remarks: ${interview.remarks}"),
                    if (interview.interviewMode == 'virtual'
                        // &&
                        // interview.meetingLink != null
                        )
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.video_call,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            launchUrl(Uri.parse(interview.meetingLink!)),
                        label: Text(
                          "Join Meeting",
                          style: AppTextStyles.button.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ),
                    if (interview.interviewMode == 'physical')
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        onPressed: () => launchUrl(Uri.parse(
                            "https://maps.google.com/?q=Interview+Location")),
                        label: Text(
                          "View Location",
                          style: AppTextStyles.button.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  int getCurrentStepIndex(List<Stage> stages) {
    // Make a copy and sort by jobStageOrder
    final sortedStages = [...stages]
      ..sort((a, b) => a.jobStageOrder.compareTo(b.jobStageOrder));

    for (int i = 0; i < sortedStages.length; i++) {
      if (sortedStages[i].statusName == CndidateStageStatus.inProgress) {
        return i;
      }
    }
    return sortedStages.length - 1;
  }
}

// DOTTED LINE PAINTER
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
        circleColor: Colors.green,
        iconColor: Colors.green,
        icon: Icons.work_outline,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Hired 🎉',
        textColor: Colors.white,
      );

    case CndidateStageStatus.selected:
      return _StageVisuals(
        circleColor: Colors.green,
        iconColor: Colors.green,
        icon: Icons.check_circle_outline,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Selected ✅',
        textColor: Colors.white,
      );

    case CndidateStageStatus.completed:
      return _StageVisuals(
        circleColor: Colors.green,
        iconColor: Colors.green,
        icon: Icons.check_circle_outline,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Selected ✅',
        textColor: Colors.white,
      );

    case CndidateStageStatus.rejected:
      return _StageVisuals(
        circleColor: Colors.red,
        iconColor: Colors.red,
        icon: Icons.cancel_outlined,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.close, size: 16, color: Colors.white),
        statusText: 'Rejected ❌',
        textColor: Colors.white,
      );

    case CndidateStageStatus.withdrawn:
      return _StageVisuals(
        circleColor: Colors.grey,
        iconColor: Colors.grey,
        icon: Icons.exit_to_app,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.close, size: 16, color: Colors.white),
        statusText: 'Withdrawn ↩️',
        textColor: Colors.black,
      );

    case CndidateStageStatus.inProgress:
      return _StageVisuals(
        circleColor: Colors.blue,
        iconColor: Colors.blue,
        icon: Icons.hourglass_top_rounded,
        lineColor: Colors.grey.shade400,
        circleChild: Text(
          '${stage.jobStageOrder + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        statusText: 'In Progress 🔄',
        textColor: Colors.white,
      );

    case CndidateStageStatus.reviewed:
      return _StageVisuals(
        circleColor: Colors.purple,
        iconColor: Colors.purple,
        icon: Icons.rate_review_outlined,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Reviewed 📝',
        textColor: Colors.white,
      );

    case CndidateStageStatus.upcoming:
    default:
      return _StageVisuals(
        circleColor: Colors.grey.shade300,
        iconColor: Colors.orange,
        icon: Icons.access_time,
        lineColor: Colors.grey.shade400,
        circleChild: Text(
          '${stage.jobStageOrder + 1}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        statusText: 'Upcoming ⏳',
        textColor: Colors.black,
      );
  }
}
