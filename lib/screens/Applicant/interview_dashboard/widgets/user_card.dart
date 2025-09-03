import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/Applicant/Interview Stages/models/userModel.dart';

class UserCard extends StatelessWidget {
  final Candidate candidate;
  final Size media;

  const UserCard({
    super.key,
    required this.candidate,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    final first = (candidate.firstName).toString();
    final last = (candidate.lastName).toString();

    String safeInitials(String a, String b) {
      final i1 = a.isNotEmpty ? a[0] : '';
      final i2 = b.isNotEmpty ? b[0] : '';
      final s = (i1 + i2).toUpperCase();
      return s.isNotEmpty ? s : '?';
    }

    final initials = safeInitials(first, last);

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
                initials,
                style: AppTextStyles.headline2.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$first $last',
                    style: AppTextStyles.headline2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  const _InfoLine(
                      icon: Icons.alternate_email, labelKey: _LabelKey.email),
                  const _InfoLine(
                      icon: Icons.home_outlined, labelKey: _LabelKey.address),
                  const _InfoLine(
                      icon: Icons.phone_rounded, labelKey: _LabelKey.phone),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal keys to pick candidate fields without changing UI/logic
enum _LabelKey { email, address, phone }

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final _LabelKey labelKey;

  const _InfoLine({
    required this.icon,
    required this.labelKey,
  });

  @override
  Widget build(BuildContext context) {
    final text = _resolveLabel(context, labelKey);

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _resolveLabel(BuildContext context, _LabelKey key) {
    final userCard = context.findAncestorWidgetOfExactType<UserCard>();
    final c = userCard?.candidate;

    switch (key) {
      case _LabelKey.email:
        return c?.email ?? '';
      case _LabelKey.address:
        return c?.address ?? '';
      case _LabelKey.phone:
        return c?.phone ?? '';
    }
  }
}
