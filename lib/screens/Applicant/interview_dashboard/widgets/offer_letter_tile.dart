import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/models/userModel.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_event.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_state.dart';
import 'package:rooster_empployee/service/apiUrls.dart';
import 'package:rooster_empployee/utils/documentUploadDialoge.dart';
import 'package:rooster_empployee/utils/webView.dart';

class OfferLetterTile extends StatelessWidget {
  final OfferLetter offerLetter;
  final Stage stage;
  final Future<void> Function(String filePath) onDownloadFile;
  final VoidCallback onRefreshAfterUpload;

  const OfferLetterTile({
    super.key,
    required this.offerLetter,
    required this.stage,
    required this.onDownloadFile,
    required this.onRefreshAfterUpload,
  });

  @override
  Widget build(BuildContext context) {
    final hasAcceptedFile = (offerLetter.acceptedLetterFile != null &&
        offerLetter.offerLetterFile!.path != null);

    return Card(
      color: AppColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Offer Letter', style: AppTextStyles.headline3),
          const SizedBox(height: 8),
          if (offerLetter.offerLetterFile != null &&
              (offerLetter.offerLetterFile!.name ?? '').isNotEmpty &&
              (offerLetter.offerLetterFile!.path ?? '').isNotEmpty)
            _SmallButton(
              icon: Icons.file_download,
              label: 'Download Offer Letter',
              onPressed: () =>
                  onDownloadFile(offerLetter.offerLetterFile!.path!),
            ),
          if (!hasAcceptedFile)
            _SmallButton(
              icon: Icons.upload_file,
              label: 'Upload Offer Letter',
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
                        child: _UploadDialogWithAutoClose(
                          assessmentId: offerLetter.id ?? '',
                          isOffer: true,
                        ),
                      ),
                    ),
                  ),
                );
                if (result == true) onRefreshAfterUpload();
              },
            ),
          if (hasAcceptedFile)
            _SmallButton(
              icon: Icons.remove_red_eye_outlined,
              label: 'Submitted Offer Letter',
              onPressed: () {
                final url =
                    '${ApiUrl.imageUrl}${offerLetter.acceptedLetterFile!.path}';
                if (Platform.isAndroid) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InAppWebViewPage(
                          url:
                              'https://docs.google.com/gview?embedded=1&url=$url',
                        ),
                      ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => InAppWebViewPage(url: url)));
                }
              },
            ),
        ]),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _SmallButton(
      {required this.icon, required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 44,
          child: ElevatedButton.icon(
            icon: Icon(icon, color: Colors.white, size: 18),
            onPressed: onPressed,
            label:
                Text(label, style: AppTextStyles.button.copyWith(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      );
}

class _UploadDialogWithAutoClose extends StatelessWidget {
  final String assessmentId;
  final bool isOffer;
  const _UploadDialogWithAutoClose(
      {required this.assessmentId, required this.isOffer});

  @override
  Widget build(BuildContext context) {
    // inside _UploadDialogWithAutoClose
    return BlocListener<UploadBloc, UploadState>(
      listenWhen: (prev, curr) =>
          prev.isSubmitting != curr.isSubmitting ||
          prev.isSuccess != curr.isSuccess ||
          prev.error != curr.error,
      listener: (context, state) {
        if (state.isSuccess) {
          // close and signal success to caller so page can refresh
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(true);
          }
          // optional: clear success after pop to avoid future accidental triggers
          context.read<UploadBloc>().add(ClearStatus());
        } else if (!state.isSubmitting && state.error != null) {
          // optional: close on failure if you want
          // Navigator.of(context).pop(false);
          // context.read<UploadBloc>().add(ClearStatus());
        }
      },
      child: SingleDocumentUploadDialogContent(
        assessmentId: assessmentId,
        isOffer: isOffer,
      ),
    );
  }
}
