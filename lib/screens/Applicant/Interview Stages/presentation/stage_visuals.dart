import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/status.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/models/userModel.dart';

class _StageVisuals {
  final Color circleColor;
  final Color iconColor;
  final IconData icon;
  final Color lineColor;
  final Widget circleChild;
  final String statusText;

  _StageVisuals({
    required this.circleColor,
    required this.iconColor,
    required this.icon,
    required this.lineColor,
    required this.circleChild,
    required this.statusText,
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
      );

    case CndidateStageStatus.selected:
      return _StageVisuals(
        circleColor: Colors.green,
        iconColor: Colors.green,
        icon: Icons.check_circle_outline,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Selected ✅',
      );

    case CndidateStageStatus.rejected:
      return _StageVisuals(
        circleColor: Colors.red,
        iconColor: Colors.red,
        icon: Icons.cancel_outlined,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.close, size: 16, color: Colors.white),
        statusText: 'Rejected ❌',
      );

    case CndidateStageStatus.withdrawn:
      return _StageVisuals(
        circleColor: Colors.grey,
        iconColor: Colors.grey,
        icon: Icons.exit_to_app,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.close, size: 16, color: Colors.white),
        statusText: 'Withdrawn ↩️',
      );

    case CndidateStageStatus.inProgress:
      return _StageVisuals(
        circleColor: Colors.blue,
        iconColor: Colors.blue,
        icon: Icons.hourglass_top_rounded,
        lineColor: Colors.grey.shade400,
        circleChild: Text(
          '${stage.jobStageOrder! + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        statusText: 'In Progress 🔄',
      );

    case CndidateStageStatus.in_Progress:
      return _StageVisuals(
        circleColor: Colors.blue,
        iconColor: Colors.blue,
        icon: Icons.hourglass_top_rounded,
        lineColor: Colors.grey.shade400,
        circleChild: Text(
          '${stage.jobStageOrder! + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        statusText: 'In Progress 🔄',
      );

    case CndidateStageStatus.reviewed:
      return _StageVisuals(
        circleColor: Colors.purple,
        iconColor: Colors.purple,
        icon: Icons.rate_review_outlined,
        lineColor: Colors.grey.shade400,
        circleChild: const Icon(Icons.check, size: 16, color: Colors.white),
        statusText: 'Reviewed 📝',
      );

    case CndidateStageStatus.upcoming:
    default:
      return _StageVisuals(
        circleColor: Colors.grey.shade300,
        iconColor: Colors.orange,
        icon: Icons.access_time,
        lineColor: Colors.grey.shade400,
        circleChild: Text(
          '${stage.jobStageOrder! + 1}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        statusText: 'Upcoming ⏳',
      );
  }
}
