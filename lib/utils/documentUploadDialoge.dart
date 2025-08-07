// widgets/single_document_upload_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_event.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_state.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/document_draft_form_widget.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class SingleDocumentUploadDialogContent extends StatefulWidget {
  final String assessmentId;
  final bool isOffer;
  const SingleDocumentUploadDialogContent(
      {super.key, required this.assessmentId, required this.isOffer});

  @override
  State<SingleDocumentUploadDialogContent> createState() =>
      _SingleDocumentUploadDialogContentState();
}

class _SingleDocumentUploadDialogContentState
    extends State<SingleDocumentUploadDialogContent> {
  @override
  void initState() {
    super.initState();
    // Ensure we start clean
    context.read<UploadBloc>()
      ..add(ClearStatus())
      ..add(AddDraft());
  }

  @override
  void dispose() {
    context.read<UploadBloc>().add(RemoveDraft(0));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ToastMessage.showMessage("Assessment Uploaded");
          Navigator.of(context).pop();
        } else if (state.error != null) {
          ToastMessage.showMessage(state.error!);
        }
      },
      builder: (context, state) {
        final draft = state.drafts.isNotEmpty ? state.drafts.first : null;

        if (draft == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return DocumentDraftFormWidget(
          shownameField: false,
          index: 0,
          name: draft.name,
          file: draft.file,
          isPhoto: draft.isPhoto,
          isSubmitting: state.isSubmitting,
          onNameChanged: (value) {
            context
                .read<UploadBloc>()
                .add(UpdateDraftName(index: 0, name: value));
          },
          onFileSelected: (file, isPhoto) {
            context
                .read<UploadBloc>()
                .add(SelectDraftFile(index: 0, file: file, isPhoto: isPhoto));
          },
          onRemove: () {
            context.read<UploadBloc>().add(RemoveDraft(0));
            Navigator.of(context).pop();
          },
          onCancel: () {
            context.read<UploadBloc>().add(RemoveDraft(0));
            Navigator.of(context).pop();
          },
          onSubmit: () {
            widget.isOffer == true
                ? context
                    .read<UploadBloc>()
                    .add(SubmitOfferLetter(offerLetterId: widget.assessmentId))
                : context
                    .read<UploadBloc>()
                    .add(SubmitDocuments(assessmentId: widget.assessmentId));
          },
        );
      },
    );
  }
}
