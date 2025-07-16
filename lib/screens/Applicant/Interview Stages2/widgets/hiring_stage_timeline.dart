import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/models/candidate_model.dart';

class HiringStageTimeline extends StatelessWidget {
  final List<HiringStage> stages;
  final int selectedIndex;
  final Function(int) onStageTap;

  const HiringStageTimeline({
    super.key,
    required this.stages,
    required this.selectedIndex,
    required this.onStageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final circleSize = isTablet ? 34.0 : 28.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(stages.length, (index) {
          final stage = stages[index];
          final status = stage.statusName.toLowerCase();

          final isCompleted = status == 'selected';
          final isCurrent = status == 'in progress';
          final isFuture = !isCompleted && !isCurrent;
          final isActive = index == selectedIndex;

          final bgColor = isCompleted
              ? AppColors.success
              : isCurrent
                  ? AppColors.warning
                  : Colors.white;

          final textColor = isCompleted || isCurrent
              ? Colors.white
              : isActive
                  ? AppColors.primary
                  : AppColors.textSecondary;

          final borderColor = isActive
              ? AppColors.primary
              : isCompleted
                  ? AppColors.success
                  : AppColors.border;

          return GestureDetector(
            onTap: () => onStageTap(index),
            child: Row(
              children: [
                if (index != 0)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: 2,
                    width: isTablet ? 40 : 30,
                    color: (stages[index - 1].statusName.toLowerCase() ==
                                'selected' ||
                            stages[index - 1].statusName.toLowerCase() ==
                                'in progress')
                        ? AppColors.success
                        : AppColors.border,
                  ),
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: circleSize,
                      width: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bgColor,
                        border: Border.all(color: borderColor, width: 2),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: isCompleted
                          ? const Icon(Icons.check,
                              size: 16, color: Colors.white)
                          : Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: isTablet ? 90 : 70,
                      child: Text(
                        stage.hiringStageName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: isActive
                              ? AppColors.primaryDark
                              : AppColors.textSecondary,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
