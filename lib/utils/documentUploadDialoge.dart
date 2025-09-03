// // widgets/single_document_upload_dialog.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_event.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_state.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/document_draft_form_widget.dart';
// import 'package:rooster_empployee/utils/tostMessage.dart';

// class SingleDocumentUploadDialogContent extends StatefulWidget {
//   final String assessmentId;
//   final bool isOffer;
//   const SingleDocumentUploadDialogContent(
//       {super.key, required this.assessmentId, required this.isOffer});

//   @override
//   State<SingleDocumentUploadDialogContent> createState() =>
//       _SingleDocumentUploadDialogContentState();
// }

// class _SingleDocumentUploadDialogContentState
//     extends State<SingleDocumentUploadDialogContent> {
//   @override
//   void initState() {
//     super.initState();
//     // Ensure we start clean
//     context.read<UploadBloc>()
//       ..add(ClearStatus())
//       ..add(AddDraft());
//   }

//   @override
//   void dispose() {
//     context.read<UploadBloc>().add(RemoveDraft(0));
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<UploadBloc, UploadState>(
//       listener: (context, state) {
//         if (state.isSuccess) {
//           ToastMessage.showMessage(
//               state.successMessage ?? "Uploaded successfully");
//           context.read<UploadBloc>().add(ClearStatus());
//           Navigator.of(context).pop();
//         } else if (state.error != null) {
//           ToastMessage.showMessage(state.error!);
//         }
//       },
//       builder: (context, state) {
//         final draft = state.drafts.isNotEmpty ? state.drafts.first : null;

//         if (draft == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return DocumentDraftFormWidget(
//           shownameField: false,
//           index: 0,
//           name: draft.name,
//           file: draft.file,
//           isPhoto: draft.isPhoto,
//           isSubmitting: state.isSubmitting,
//           onNameChanged: (value) {
//             context
//                 .read<UploadBloc>()
//                 .add(UpdateDraftName(index: 0, name: value));
//           },
//           onFileSelected: (file, isPhoto) {
//             context
//                 .read<UploadBloc>()
//                 .add(SelectDraftFile(index: 0, file: file, isPhoto: isPhoto));
//           },
//           onRemove: () {
//             context.read<UploadBloc>().add(RemoveDraft(0));
//             Navigator.of(context).pop();
//           },
//           onCancel: () {
//             context.read<UploadBloc>().add(RemoveDraft(0));
//             Navigator.of(context).pop();
//           },
//           onSubmit: () {
//             widget.isOffer == true
//                 ? context
//                     .read<UploadBloc>()
//                     .add(SubmitOfferLetter(offerLetterId: widget.assessmentId))
//                 : context
//                     .read<UploadBloc>()
//                     .add(SubmitDocuments(assessmentId: widget.assessmentId));
//           },
//         );
//       },
//     );
//   }
// }
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
  const SingleDocumentUploadDialogContent({
    super.key,
    required this.assessmentId,
    required this.isOffer,
  });

  @override
  State<SingleDocumentUploadDialogContent> createState() =>
      _SingleDocumentUploadDialogContentState();
}

class _SingleDocumentUploadDialogContentState
    extends State<SingleDocumentUploadDialogContent> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<UploadBloc>();
    // start clean + 1 draft
    bloc
      ..add(ClearStatus())
      ..add(AddDraft());
  }

  @override
  void dispose() {
    // Guard to avoid index errors if already removed via cancel/submit
    final bloc = context.read<UploadBloc>();
    if (bloc.state.drafts.isNotEmpty) {
      bloc.add(RemoveDraft(0));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadBloc, UploadState>(
      listenWhen: (prev, curr) =>
          prev.isSubmitting != curr.isSubmitting ||
          prev.isSuccess != curr.isSuccess ||
          prev.error != curr.error,
      listener: (context, state) {
        if (state.isSuccess) {
          ToastMessage.showMessage(
              state.successMessage ?? "Uploaded successfully");

          // Grab the bloc before popping (context may be disposed after pop)
          final bloc = context.read<UploadBloc>();
          // return TRUE so caller knows to refresh
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(true);
          }
          // clear status after closing
          bloc.add(ClearStatus());
        } else if (!state.isSubmitting && state.error != null) {
          ToastMessage.showMessage(state.error!);
          // If you want to auto-close on failure, you could:
          // final bloc = context.read<UploadBloc>();
          // Navigator.of(context).pop(false);
          // bloc.add(ClearStatus());
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
            // remove + close with FALSE (no refresh)
            final bloc = context.read<UploadBloc>();
            if (bloc.state.drafts.isNotEmpty) {
              bloc.add(RemoveDraft(0));
            }
            Navigator.of(context).pop(false);
          },
          onCancel: () {
            // cancel + close with FALSE (no refresh)
            final bloc = context.read<UploadBloc>();
            if (bloc.state.drafts.isNotEmpty) {
              bloc.add(RemoveDraft(0));
            }
            Navigator.of(context).pop(false);
          },
          onSubmit: () {
            if (widget.isOffer) {
              context
                  .read<UploadBloc>()
                  .add(SubmitOfferLetter(offerLetterId: widget.assessmentId));
            } else {
              context
                  .read<UploadBloc>()
                  .add(SubmitDocuments(assessmentId: widget.assessmentId));
            }
          },
        );
      },
    );
  }
}
