import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/models/userModel.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/utils/navigation.dart';
import 'package:rooster_empployee/screens/Applicant/interview_dashboard/widgets/small_button.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
import 'package:rooster_empployee/utils/documentUploadDialoge.dart';

class AssessmentTile extends StatelessWidget {
  final Assessment assessment;
  final Future<void> Function(String fileIdOrPath) onDownloadTaskFile;

  /// Called only after the upload dialog completes with success.
  final VoidCallback onRefreshAfterUpload;

  const AssessmentTile({
    super.key,
    required this.assessment,
    required this.onDownloadTaskFile,
    required this.onRefreshAfterUpload,
  });

  @override
  Widget build(BuildContext context) {
    final hasTaskFile = (assessment.taskFileId ?? '').isNotEmpty &&
        (assessment.taskFile?.path ?? '').isNotEmpty;

    final submittedPath = assessment.submittedFile?.path ?? '';
    final hasSubmitted = submittedPath.isNotEmpty;

    return Card(
      color: AppColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assessment.title ?? '',
              style: AppTextStyles.bodyLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text('Task: ${assessment.description}',
                style: AppTextStyles.bodySmall),

            if (hasTaskFile)
              SmallButton(
                icon: Icons.file_download,
                label: 'Download Task File',
                onPressed: () => onDownloadTaskFile(assessment.taskFile!.path!),
              ),

            // Upload (auto-reload after dialog returns true)
            if (!hasSubmitted)
              SmallButton(
                icon: Icons.upload_file,
                label: 'Upload Task File',
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: BlocProvider.value(
                          value: context.read<UploadBloc>(),
                          child: SingleDocumentUploadDialogContent(
                            assessmentId: assessment.id ?? '',
                            isOffer: false,
                          ),
                        ),
                      ),
                    ),
                  );
                  if (result == true) onRefreshAfterUpload();
                },
              ),

            if (hasSubmitted)
              SmallButton(
                icon: Icons.remove_red_eye_outlined,
                label: 'View Submitted File',
                onPressed: () => openApiFile(context, submittedPath),
              ),
          ],
        ),
      ),
    );
  }
}
