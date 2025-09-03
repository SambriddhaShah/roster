import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/constants/status.dart';
import 'package:rooster_empployee/screens/Applicant/Interview Stages/models/userModel.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/utils/stage_visuals.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/utils/date_formatting.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/small_button.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/icon_text.dart';
import 'package:url_launcher/url_launcher.dart';

typedef AssessmentBuilder = Widget Function(Assessment assessment);
typedef OfferLetterBuilder = Widget Function(
    OfferLetter offerLetter, Stage stage);

class StageDetails extends StatelessWidget {
  final Stage stage;
  final List<Interview> interviews;

  /// Optional slots so the parent can inject Assessment/Offer tiles.
  /// If null, nothing is rendered for that section (current behavior).
  final AssessmentBuilder? assessmentBuilder;
  final OfferLetterBuilder? offerLetterBuilder;

  const StageDetails({
    super.key,
    required this.stage,
    required this.interviews,
    this.assessmentBuilder,
    this.offerLetterBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final visuals = getStageVisuals(stage);

    final canShowBlocks = stage.statusName != CndidateStageStatus.completed &&
        stage.statusName != CndidateStageStatus.hired &&
        stage.statusName != CndidateStageStatus.selected &&
        stage.statusName != CndidateStageStatus.rejected;

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
        if (canShowBlocks) ...[
          _InterviewList(stage: stage, interviews: interviews),
          const SizedBox(height: 12),
        ],

        // Assessments (optional slot)
        if (canShowBlocks &&
            assessmentBuilder != null &&
            stage.assessments.isNotEmpty)
          ...stage.assessments.map((a) => KeyedSubtree(
                key: ValueKey('assess-${a.id ?? a.title ?? ''}'),
                child: assessmentBuilder!(a),
              )),

        // Offer Letter (optional slot)
        if (canShowBlocks &&
            offerLetterBuilder != null &&
            stage.hiringStageName == 'Offer Letter' &&
            stage.offerLetters.first.acceptedLetterFile != null) ...[
          const SizedBox(height: 12),
          KeyedSubtree(
            key: ValueKey('offer-${stage.offerLetters.first.id}'),
            child: offerLetterBuilder!(stage.offerLetters.first, stage),
          ),
        ],
      ],
    );
  }
}

class _InterviewList extends StatelessWidget {
  final Stage stage;
  final List<Interview> interviews;

  const _InterviewList({required this.stage, required this.interviews});

  @override
  Widget build(BuildContext context) {
    final matchingInterviews = stage.interviews; // same as original
    if (matchingInterviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Interviews', style: AppTextStyles.headline3),
        const SizedBox(height: 8),
        ...matchingInterviews.map((interview) {
          final meetingLink = interview.meetingLink ?? '';
          final isVirtual = (interview.interviewMode ?? '') == 'virtual';
          final isPhysical = (interview.interviewMode ?? '') == 'physical';

          return Card(
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
                  IconText(
                    icon: Icons.event,
                    text: formatInterviewDateUtil(interview.scheduledAt ?? ''),
                  ),
                  IconText(
                    icon: Icons.flag_outlined,
                    text: 'Round: ${interview.roundName ?? '-'}',
                  ),
                  if ((interview.roundDescription ?? '').isNotEmpty)
                    IconText(
                      icon: Icons.notes_outlined,
                      text: interview.roundDescription!,
                    ),
                  IconText(
                    icon: Icons.forum_outlined,
                    text:
                        'Mode: ${(interview.interviewMode ?? '').toUpperCase()}',
                  ),
                  if ((interview.remarks ?? '').isNotEmpty)
                    IconText(
                      icon: Icons.chat_bubble_outline,
                      text: 'Remarks: ${interview.remarks}',
                    ),
                  const SizedBox(height: 8),
                  if (isVirtual && meetingLink.isNotEmpty)
                    SmallButton(
                      icon: Icons.video_call,
                      label: 'Join Meeting',
                      onPressed: () => launchUrl(Uri.parse(meetingLink)),
                    ),
                  if (isPhysical)
                    SmallButton(
                      icon: Icons.location_on,
                      label: 'View Location',
                      onPressed: () => launchUrl(
                        Uri.parse(
                          'https://maps.google.com/?q=Interview+Location',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
