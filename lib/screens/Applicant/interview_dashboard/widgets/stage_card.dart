import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/constants/status.dart';
import 'package:rooster_empployee/screens/Applicant/Interview Stages/models/userModel.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/painter/dottes_line_painter.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/utils/stage_visuals.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/stage_details.dart';

// NEW: type defs come from StageDetails
typedef AssessmentBuilder = Widget Function(Assessment assessment);
typedef OfferLetterBuilder = Widget Function(
    OfferLetter offerLetter, Stage stage);

class StageCard extends StatelessWidget {
  final Stage stage;
  final int index;
  final bool expanded;
  final bool showLine;
  final int currentStep;
  final Size media; // kept for API parity (not used internally)
  final List<Interview> interviews;
  final VoidCallback? onToggle; // parent controls expanded state

  // NEW: pass-thru builders to StageDetails
  final AssessmentBuilder? assessmentBuilder;
  final OfferLetterBuilder? offerLetterBuilder;

  const StageCard({
    super.key,
    required this.stage,
    required this.index,
    required this.expanded,
    required this.showLine,
    required this.currentStep,
    required this.media,
    required this.interviews,
    this.onToggle,
    this.assessmentBuilder,
    this.offerLetterBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final visuals = getStageVisuals(stage);
    final bool isUpcoming = stage.statusName == CndidateStageStatus.upcoming ||
        (stage.jobStageOrder ?? 999999) > currentStep;

    return GestureDetector(
      onTap: () {
        if (!isUpcoming && onToggle != null) onToggle!();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(left: 40, bottom: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.none,
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
                      StageDetails(
                        stage: stage,
                        interviews: interviews,
                        // NEW: wire slots through
                        assessmentBuilder: assessmentBuilder,
                        offerLetterBuilder: offerLetterBuilder,
                      ),
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
}
