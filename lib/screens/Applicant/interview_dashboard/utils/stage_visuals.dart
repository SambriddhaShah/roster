import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/status.dart';
import 'package:rooster_empployee/screens/Applicant/Interview Stages/models/userModel.dart';

class StageVisuals {
  final Color circleColor;
  final Color iconColor;
  final IconData icon;
  final Color lineColor;
  final Widget circleChild;
  final String statusText;
  final Color textColor;

  const StageVisuals({
    required this.circleColor,
    required this.iconColor,
    required this.icon,
    required this.lineColor,
    required this.circleChild,
    required this.statusText,
    required this.textColor,
  });
}

StageVisuals getStageVisuals(Stage stage) {
  switch (stage.statusName) {
    case CndidateStageStatus.hired:
      return const StageVisuals(
        circleColor: AppColors.success,
        iconColor: AppColors.success,
        icon: Icons.work_outline,
        lineColor: AppColors.divider,
        circleChild: Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Hired',
        textColor: Colors.white,
      );
    case CndidateStageStatus.selected:
      return const StageVisuals(
        circleColor: AppColors.success,
        iconColor: AppColors.success,
        icon: Icons.check_circle_outline,
        lineColor: AppColors.divider,
        circleChild: Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Selected',
        textColor: Colors.white,
      );
    case CndidateStageStatus.completed:
      return const StageVisuals(
        circleColor: AppColors.success,
        iconColor: AppColors.success,
        icon: Icons.check_circle_outline,
        lineColor: AppColors.divider,
        circleChild: Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Completed',
        textColor: Colors.white,
      );
    case CndidateStageStatus.rejected:
      return const StageVisuals(
        circleColor: AppColors.error,
        iconColor: AppColors.error,
        icon: Icons.cancel_outlined,
        lineColor: AppColors.divider,
        circleChild: Icon(Icons.close, size: 16, color: Colors.white),
        statusText: 'Rejected',
        textColor: Colors.white,
      );
    case CndidateStageStatus.withdrawn:
      return const StageVisuals(
        circleColor: AppColors.border,
        iconColor: AppColors.border,
        icon: Icons.exit_to_app,
        lineColor: AppColors.divider,
        circleChild: Icon(Icons.close, size: 16, color: Colors.white),
        statusText: 'Withdrawn',
        textColor: AppColors.textPrimary,
      );
    case CndidateStageStatus.inProgress:
    case CndidateStageStatus.in_Progress:
      return StageVisuals(
        circleColor: AppColors.inProgress,
        iconColor: AppColors.inProgress,
        icon: Icons.hourglass_top_rounded,
        lineColor: AppColors.divider,
        circleChild: Text(
          '${stage.jobStageOrder! + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        statusText: 'In Progress',
        textColor: Colors.white,
      );
    case CndidateStageStatus.reviewed:
      return const StageVisuals(
        circleColor: Colors.purple,
        iconColor: Colors.purple,
        icon: Icons.rate_review_outlined,
        lineColor: AppColors.divider,
        circleChild: Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Reviewed',
        textColor: Colors.white,
      );
    case CndidateStageStatus.upcoming:
    default:
      return StageVisuals(
        circleColor: AppColors.divider,
        iconColor: AppColors.warning,
        icon: Icons.access_time,
        lineColor: AppColors.divider,
        circleChild: Text(
          '${stage.jobStageOrder! + 1}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        statusText: 'Upcoming',
        textColor: AppColors.textPrimary,
      );
  }
}
