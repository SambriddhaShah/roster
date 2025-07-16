// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_event.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_state.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/file_upload_title.dart';
// import 'package:rooster_empployee/utils/tostMessage.dart';

// class UploadDocumentsPage extends StatefulWidget {
//   const UploadDocumentsPage({Key? key}) : super(key: key);

//   @override
//   State<UploadDocumentsPage> createState() => _UploadDocumentsPageState();
// }

// class _UploadDocumentsPageState extends State<UploadDocumentsPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<UploadBloc>().add(LoadInitialFiles());
//   }

//   void _pickFile(BuildContext context, String type) async {
//     if (type == "photo") {
//       final ImagePicker picker = ImagePicker();

//       final source = await showModalBottomSheet<ImageSource>(
//         context: context,
//         builder: (_) => SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text("Take a Photo"),
//                 onTap: () => Navigator.pop(context, ImageSource.camera),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text("Choose from Gallery"),
//                 onTap: () => Navigator.pop(context, ImageSource.gallery),
//               ),
//             ],
//           ),
//         ),
//       );

//       if (source != null) {
//         final XFile? image = await picker.pickImage(source: source);
//         if (image != null) {
//           final file = File(image.path);
//           context.read<UploadBloc>().add(FileSelected("photo", [file]));
//         }
//       }
//     } else {
//       // default file_picker for other types
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: type == 'certificates',
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
//       );

//       if (result != null) {
//         final files = result.paths.map((p) => File(p!)).toList();
//         context.read<UploadBloc>().add(FileSelected(type, files));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Upload Documents")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocConsumer<UploadBloc, UploadState>(
//           listener: (context, state) {
//             if (state.isSuccess) {
//               ToastMessage.showMessage("Documents uploaded successfully!");
//             } else if (state.error != null) {
//               ToastMessage.showMessage(state.error!);
//             }
//           },
//           builder: (context, state) {
//             if (state.categories.isEmpty &&
//                 state.error == null &&
//                 !state.isSubmitting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             return ListView(
//               children: [
//                 const Text(
//                   "Please upload the following documents:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 20),
//                 ...state.categories.map((category) {
//                   return FileUploadTile(
//                     title: category.type,
//                     fileList: category.localFiles,
//                     remoteFileList: category.remoteFiles,
//                     onPressed: () => _pickFile(context, category.type),
//                   );
//                 }),
//                 const SizedBox(height: 30),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.upload),
//                   label: const Text("Submit"),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   onPressed: state.isAllValid
//                       ? () => context.read<UploadBloc>().add(SubmitDocuments())
//                       : null,
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// upload_documents_page.dart
// upload_documents_page.dart (SINGLE FORM MODE)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_event.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_state.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/document_draft_form_widget.dart';
import 'package:rooster_empployee/service/apiUrls.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';
import 'package:rooster_empployee/utils/webView.dart';

class UploadDocumentsPage extends StatefulWidget {
  final bool showBackButton;
  const UploadDocumentsPage({super.key, required this.showBackButton});

  @override
  State<UploadDocumentsPage> createState() => _UploadDocumentsPageState();
}

class _UploadDocumentsPageState extends State<UploadDocumentsPage> {
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    context.read<UploadBloc>().add(LoadInitialFiles());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ToastMessage.showMessage(
              state.successMessage ?? "Documents uploaded successfully!");
          context.read<UploadBloc>().add(ClearStatus());
          context.read<UploadBloc>().add(LoadInitialFiles());

          setState(() {
            showForm = false;
          });
        } else if (state.error != null) {
          ToastMessage.showMessage(state.error!);
        }
      },
      builder: (context, state) {
        final draft = state.drafts.isNotEmpty ? state.drafts.first : null;
        final isTablet = MediaQuery.of(context).size.width >= 600;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: widget.showBackButton,
            title: const Text("Upload Documents"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 32 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isLoading)
                  SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      width: double.infinity,
                      child: const Center(child: CircularProgressIndicator())),

                /// ➕ Add Document Toggle Button
                showForm
                    ? SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Add Document"),
                            onPressed: () {
                              setState(() {
                                showForm = !showForm;
                                if (showForm) {
                                  context.read<UploadBloc>().add(AddDraft());
                                } else {
                                  // Clear draft when cancelled
                                  context
                                      .read<UploadBloc>()
                                      .add(RemoveDraft(0));
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(180, 50),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                const SizedBox(height: 16),

                /// 📝 Single Draft Form
                if (showForm && draft != null)
                  DocumentDraftFormWidget(
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
                      context.read<UploadBloc>().add(SelectDraftFile(
                          index: 0, file: file, isPhoto: isPhoto));
                    },
                    onRemove: () {
                      context.read<UploadBloc>().add(RemoveDraft(0));
                      setState(() {
                        showForm = false;
                      });
                    },
                    onCancel: () {
                      context.read<UploadBloc>().add(RemoveDraft(0));
                      setState(() {
                        showForm = false;
                      });
                    },
                    onSubmit: () {
                      context.read<UploadBloc>().add(SubmitAllDocuments());
                    },
                  ),

                /// 🔄 Remote Uploaded Files
                if (!state.isLoading) ...[
                  const Text(
                    "Uploaded Documents",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  if (state.remoteFiles.isEmpty)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: const [
                            Icon(Icons.info_outline, color: Colors.grey),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "No documents uploaded yet.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.remoteFiles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final file = state.remoteFiles[i];
                        final isDeleting =
                            state.deletingFileIds.contains(file.id);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file,
                                  color: Colors.blueGrey),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  file.type,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // isDeleting
                              //     ? const SizedBox(
                              //         width: 20,
                              //         height: 20,
                              //         child: CircularProgressIndicator(
                              //             strokeWidth: 2),
                              //       )
                              //     : IconButton(
                              //         icon: const Icon(Icons.delete_forever,
                              //             color: Colors.red),
                              //         onPressed: () => context
                              //             .read<UploadBloc>()
                              //             .add(DeleteRemoteFile(file.id)),
                              //       ),
                              GestureDetector(
                                onTap: () {
                                  print("View file: ${file.path}");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => InAppWebViewPage(
                                        url: '${ApiUrl.imageUrl}${file.path}',
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Text("View",
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 8),
                                    Icon(Icons.remove_red_eye_outlined,
                                        color: AppColors.primary),
                                    // IconButton(
                                    //   icon: const Icon(
                                    //       Icons.remove_red_eye_outlined,
                                    //       color: AppColors.primary),
                                    //   onPressed: () {},
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
