import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/Applicant/Interview Stages/models/userModel.dart';

typedef StageCardBuilder = Widget Function(
  Stage stage,
  int index,
  bool showLine,
);

class JobAndStagesCard extends StatelessWidget {
  final Job job;
  final List<Stage> stages;
  final int currentStep;
  final Size media;
  final List<JobApplication> jobApplications;
  final bool showFullJobDesc;
  final VoidCallback onToggleJobDesc;

  /// We don't manipulate `_expandedStates` here to avoid state duplication.
  /// Stage expansion is handled by the parent via `stageCardBuilder`.
  final StageCardBuilder stageCardBuilder;

  const JobAndStagesCard({
    super.key,
    required this.job,
    required this.stages,
    required this.currentStep,
    required this.media,
    required this.jobApplications,
    required this.showFullJobDesc,
    required this.onToggleJobDesc,
    required this.stageCardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final sortedStages = [...stages]
      ..sort((a, b) => a.jobStageOrder!.compareTo(b.jobStageOrder!));

    final jobTitle = job.title ?? 'fewfe';
    final jobDescription = job.description ?? 'fdwedfweewf';

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
            Text(
              jobTitle,
              style: AppTextStyles.headline2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Job Description Toggle
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onToggleJobDesc,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Description', style: AppTextStyles.bodyLarge),
                  const SizedBox(width: 6),
                  Icon(
                    showFullJobDesc ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.icon,
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              crossFadeState: showFullJobDesc
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(jobDescription, style: AppTextStyles.bodySmall),
              ),
            ),

            const SizedBox(height: 20),
            Text('📌 Hiring Stages', style: AppTextStyles.headline4),
            const SizedBox(height: 12),

            ...List.generate(sortedStages.length, (index) {
              final stage = sortedStages[index];
              final showLine = index != sortedStages.length - 1;

              // Stable key helps Flutter preserve subtree state if the list changes.
              return KeyedSubtree(
                key: ValueKey(stage.jobStageId ?? 'stage-$index'),
                child: stageCardBuilder(stage, index, showLine),
              );
            }),
          ],
        ),
      ),
    );
  }
}
