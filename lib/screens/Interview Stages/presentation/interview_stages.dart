import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/Interview%20Stages/models/model.dart';
import 'package:rooster_empployee/utils/drawer_applicant.dart';
import 'package:url_launcher/url_launcher.dart';

class InterviewDashboardPage extends StatefulWidget {
  const InterviewDashboardPage({Key? key}) : super(key: key);

  @override
  State<InterviewDashboardPage> createState() => _InterviewDashboardPageState();
}

class _InterviewDashboardPageState extends State<InterviewDashboardPage> { 
  late Future<ApiResponse> _futureData;
  List<bool> _expandedStates = [];
  bool _showFullJobDesc = false;

  @override
  void initState() {
    super.initState();
    _futureData = loadJsonData();
  }

  Future<ApiResponse> loadJsonData() async {
    await Future.delayed(const Duration(seconds: 2));
    final String jsonString =
        await rootBundle.loadString('assets/response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final data = ApiResponse.fromJson(jsonMap);

    _expandedStates = List.filled(data.interviewStages.length, false);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: DrawerWidgetApplicant(),
      body: FutureBuilder<ApiResponse>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load data."));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No interview data found."));
          }

          final user = snapshot.data!.user;
          final job = snapshot.data!.job;
          final stages = snapshot.data!.interviewStages;
          final currentStep = getCurrentStepIndex(stages);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildUserCard(user, media),
                buildJobAndStagesCard(job, stages, currentStep, media),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildJobAndStagesCard(
      Job job, List<InterviewStage> stages, int currentStep, Size media) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🧑‍💼 Job Title
            Text(
              job.title,
              style: TextStyle(
                fontSize: media.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// 🔽 Description Toggle
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                setState(() {
                  _showFullJobDesc = !_showFullJobDesc;
                });
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

            /// 🧾 Expandable Job Info
            AnimatedCrossFade(
              crossFadeState: _showFullJobDesc
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text("🏢 ${job.company}"),
                  Text("📍 ${job.location}"),
                  Text("💼 Experience: ${job.experienceRequired}"),
                  Text("📃 Type: ${job.employmentType}"),
                  const SizedBox(height: 12),
                  Text("🔹 Responsibilities:",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...job.descriptionBullets.map(
                    (desc) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text("• $desc"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (job.skills.isNotEmpty) ...[
                    Text("🛠️ Skills:",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: job.skills
                          .map((skill) => Chip(label: Text(skill)))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📋 Interview Stages
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📌 Interview Stages",
                      style: TextStyle(
                          fontSize: media.width * 0.045,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...List.generate(stages.length, (index) {
                    return buildCustomExpandableStageCard(
                      stages[index],
                      index,
                      currentStep,
                      index != stages.length - 1,
                      media,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildJobAndStagesCard(
  //     Job job, List<InterviewStage> stages, int currentStep, Size media) {
  //   return Card(
  //     elevation: 6,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(job.title,
  //               style: TextStyle(
  //                   fontSize: media.width * 0.05, fontWeight: FontWeight.bold)),
  //           const SizedBox(height: 6),
  //           Text("🏢 ${job.company}"),
  //           Text("📍 ${job.location}"),
  //           Text("💼 Experience: ${job.experienceRequired}"),
  //           Text("📃 Type: ${job.employmentType}"),
  //           const SizedBox(height: 12),
  //           Text("🔹 Responsibilities:",
  //               style: const TextStyle(fontWeight: FontWeight.bold)),
  //           ...List.generate(
  //             _showFullJobDesc
  //                 ? job.descriptionBullets.length
  //                 : (job.descriptionBullets.length > 4
  //                     ? 4
  //                     : job.descriptionBullets.length),
  //             (i) => Text("• ${job.descriptionBullets[i]}"),
  //           ),
  //           const SizedBox(height: 8),
  //           if (job.descriptionBullets.length > 4)
  //             Center(
  //               child: TextButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     _showFullJobDesc = !_showFullJobDesc;
  //                   });
  //                 },
  //                 child: Text(
  //                   _showFullJobDesc ? "Show Less ▲" : "Show More ▼",
  //                   style: const TextStyle(
  //                       fontWeight: FontWeight.w600, color: Colors.black),
  //                 ),
  //               ),
  //             ),
  //           if (job.skills.isNotEmpty) ...[
  //             const SizedBox(height: 10),
  //             Text("🛠️ Skills:",
  //                 style: const TextStyle(fontWeight: FontWeight.bold)),
  //             Wrap(
  //               spacing: 8,
  //               children: job.skills
  //                   .map((skill) => Chip(label: Text(skill)))
  //                   .toList(),
  //             ),
  //           ],
  //           const SizedBox(height: 20),
  //           Container(
  //             // padding: const EdgeInsets.all(8),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(12),
  //               // color: Colors.grey.shade100,
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text("📌 Interview Stages",
  //                     style: TextStyle(
  //                         fontSize: media.width * 0.045,
  //                         fontWeight: FontWeight.bold)),
  //                 const SizedBox(height: 10),
  //                 ...List.generate(stages.length, (index) {
  //                   return buildCustomExpandableStageCard(
  //                     stages[index],
  //                     index,
  //                     currentStep,
  //                     index != stages.length - 1,
  //                     media,
  //                   );
  //                 }),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildUserCard(User user, Size media) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: media.width * 0.1,
              backgroundImage: NetworkImage(user.profileImage),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: TextStyle(
                          fontSize: media.width * 0.06,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('📧 ${user.email}'),
                  Text('🏠 ${user.address}'),
                  Text('📱 ${user.phone}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomExpandableStageCard(
    InterviewStage stage,
    int index,
    int currentStep,
    bool showLine,
    Size media,
  ) {
    bool expanded = _expandedStates[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedStates[index] = !_expandedStates[index];
        });
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
                            stage.status == 'passed'
                                ? Icons.check_circle_outline
                                : stage.status == 'failed'
                                    ? Icons.cancel_outlined
                                    : Icons.access_time,
                            color: stage.status == 'passed'
                                ? Colors.green
                                : stage.status == 'failed'
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              stage.stageName,
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
                        buildStageDetails(stage),
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
                    radius: 14,
                    backgroundColor: index < currentStep
                        ? Colors.green
                        : index == currentStep
                            ? Colors.blue
                            : Colors.grey.shade300,
                    child: index < currentStep
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: index == currentStep
                                  ? Colors.white
                                  : Colors.black,
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
                          color: Colors.grey.shade400,
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

  Widget buildStageDetails(InterviewStage stage) {
    switch (stage.status) {
      case 'passed':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("✅ Status: Passed"),
            Text("👤 Interviewer: ${stage.interviewer}"),
            Text("📝 Task Done: ${stage.taskDone}"),
            Text("💬 Comments: ${stage.comments}"),
          ],
        );
      case 'failed':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("❌ Status: Failed"),
            Text("Reason: ${stage.failureReason}"),
            if (stage.deactivationMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(stage.deactivationMessage!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
              ),
          ],
        );
      case 'ongoing':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔄 Status: Ongoing"),
            Text("👤 Interviewer: ${stage.interviewer}"),
            Text("📄 Description: ${stage.description}"),
            const SizedBox(height: 10),
            if (stage.type == 'virtual' && stage.meetingLink != null)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse(stage.meetingLink!)),
                  child: Text("Join Virtual Meeting 🎦",
                      style: AppTextStyles.button.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      )),
                ),
              ),
            if (stage.type == 'physical')
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse(
                      "https://maps.google.com/?q=Interview+Location")),
                  child: Text("View Location 📍",
                      style: AppTextStyles.button.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      )),
                ),
              ),
            if (stage.type == 'task')
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse("/path/to/task.pdf")),
                  child: Text("Download the Given Task",
                      style: AppTextStyles.button.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      )),
                ),
              ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  int getCurrentStepIndex(List<InterviewStage> stages) {
    for (int i = 0; i < stages.length; i++) {
      if (stages[i].status == 'ongoing') return i;
    }
    return stages.length - 1;
  }

  Future<void> launchUrl(Uri url) async {
    if (!await launchUrlExternal(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the link")),
      );
    }
  }

  Future<bool> launchUrlExternal(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }
}

// 🧩 DOTTED LINE PAINTER
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
