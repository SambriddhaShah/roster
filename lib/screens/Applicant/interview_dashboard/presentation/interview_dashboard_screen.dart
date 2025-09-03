import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/status.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/models/userModel.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/utils/navigation.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/assessment_tile.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/job_and_stages_card.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/offer_letter_tile.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/stage_card.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/user_card.dart';
import 'package:rooster_empployee/service/apiService.dart';
import 'package:rooster_empployee/service/apiUrls.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/utils/drawer_applicant.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

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
          ..sort((a, b) => a.jobStageOrder!.compareTo(b.jobStageOrder!));
        _expandedStates = List<bool>.filled(sortedStages.length, false);
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
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      drawer: const DrawerWidgetApplicant(),
      body: FutureBuilder<CandidateResponse?>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load data.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No interview data found.'));
          }

          final candidate = snapshot.data!.data.candidate;
          final jobApplications = snapshot.data!.data.jobs;

          if (jobApplications.isEmpty) {
            return const Center(child: Text('No job applications found.'));
          }

          final job = jobApplications.first.job;
          final stages = jobApplications.first.stages;
          final currentStep = getCurrentStepIndex(stages);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserCard(candidate: candidate, media: media),
                const SizedBox(height: 16),
                JobAndStagesCard(
                  job: job ?? Job(),
                  stages: stages,
                  currentStep: currentStep,
                  media: media,
                  jobApplications: jobApplications,
                  showFullJobDesc: _showFullJobDesc,
                  onToggleJobDesc: () =>
                      setState(() => _showFullJobDesc = !_showFullJobDesc),
                  stageCardBuilder: (stage, index, showLine) {
                    // protect from OOB in edge cases
                    final expanded =
                        (index >= 0 && index < _expandedStates.length)
                            ? _expandedStates[index]
                            : false;

                    return StageCard(
                      stage: stage,
                      index: index,
                      expanded: expanded,
                      showLine: showLine,
                      currentStep: currentStep,
                      media: media,
                      interviews: jobApplications.first.interviews,
                      onToggle: () {
                        if (index >= 0 && index < _expandedStates.length) {
                          setState(() => _expandedStates[index] = !expanded);
                        }
                      },

                      // NEW: inject tiles
                      assessmentBuilder: (a) => AssessmentTile(
                        assessment: a,
                        onDownloadTaskFile: _downloadTaskFile,
                        onRefreshAfterUpload: () =>
                            setState(() => _futureData = loadJsonData()),
                      ),
                      offerLetterBuilder: (offer, s) => OfferLetterTile(
                        offerLetter: offer,
                        stage: s,
                        onDownloadFile: (p) => _downloadTaskFile(p),
                        onRefreshAfterUpload: () =>
                            setState(() => _futureData = loadJsonData()),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
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

  Future<void> _downloadTaskFile(String relativePath) async {
    if (relativePath.isEmpty) return;

    final uri = Uri.parse('${ApiUrl.imageUrl}$relativePath');

    try {
      await launchExternalUrl(uri);
    } catch (e) {
      debugPrint('Error launching file: $e');
      ToastMessage.showMessage('Could not open file.');
    }
  }

  Future<void> _viewTaskFile(BuildContext context, String relativePath) async {
    if (relativePath.isEmpty) return;
    await openApiFile(context, relativePath);
  }
}
