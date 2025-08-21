import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_event.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_state.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/document_draft_form_widget.dart';
import 'package:rooster_empployee/service/apiUrls.dart';
import 'package:rooster_empployee/utils/imageView.dart';
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
                    shownameField: true,
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
                              buildFileIcon(file.path),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  file.type,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  print("View file: ${file.path}");

                                  if (Platform.isAndroid) {
                                    final fullUrl =
                                        '${ApiUrl.imageUrl}${file.path}';
                                    _openDocumentSmart(context, fullUrl);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => InAppWebViewPage(
                                          url: '${ApiUrl.imageUrl}${file.path}',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Row(
                                  children: [
                                    //View
                                    Text("",
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

                              isDeleting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.red, strokeWidth: 2),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        context
                                            .read<UploadBloc>()
                                            .add(DeleteRemoteFile(file.id));
                                      },
                                      child: const Row(
                                        children: [
                                          //delete
                                          Text("",
                                              style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 8),
                                          Icon(Icons.delete_outline_rounded,
                                              color: AppColors.error),
                                          // IconButton(
                                          //   icon: const Icon(
                                          //       Icons.remove_red_eye_outlined,
                                          //       color: AppColors.primary),
                                          //   onPressed: () {},
                                          // ),
                                        ],
                                      ),
                                    ),
                              // IconButton(
                              //   icon: const Icon(Icons.delete_forever,
                              //       color: Colors.red),
                              //   onPressed: () => context
                              //       .read<UploadBloc>()
                              //       .add(DeleteRemoteFile(file.id)),
                              // ),
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

enum FileType { image, pdf, word, excel, ppt, text, video, archive, other }

FileType getFileType(String fileName) {
  final lower = fileName.toLowerCase();

  if (lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.png') ||
      lower.endsWith('.gif') ||
      lower.endsWith('.bmp') ||
      lower.endsWith('.webp')) return FileType.image;

  if (lower.endsWith('.pdf')) return FileType.pdf;
  if (lower.endsWith('.doc') || lower.endsWith('.docx')) return FileType.word;
  if (lower.endsWith('.xls') || lower.endsWith('.xlsx')) return FileType.excel;
  if (lower.endsWith('.ppt') || lower.endsWith('.pptx')) return FileType.ppt;
  if (lower.endsWith('.txt')) return FileType.text;
  if (lower.endsWith('.zip') || lower.endsWith('.rar')) return FileType.archive;
  if (lower.endsWith('.mp4') ||
      lower.endsWith('.mov') ||
      lower.endsWith('.avi')) return FileType.video;

  return FileType.other;
}

String getIconAssetForFileType(FileType type) {
  switch (type) {
    case FileType.image:
      return 'assets/photo.png';
    case FileType.pdf:
      return 'assets/pdf.png';
    case FileType.word:
      return 'assets/doc.png';
    case FileType.excel:
      return 'assets/xls.png';
    case FileType.ppt:
      return 'assets/ppt.png';
    case FileType.text:
      return 'assets/txt-file.png';

    default:
      return 'assets/word.png';
  }
}

void _openDocumentSmart(BuildContext context, String url) {
  final l = url.toLowerCase();
  final isPdf = l.endsWith('.pdf');
  final isImage = l.endsWith('.png') ||
      l.endsWith('.jpg') ||
      l.endsWith('.jpeg') ||
      l.endsWith('.webp') ||
      l.endsWith('.gif') ||
      l.endsWith('.bmp');

  if (isImage) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ImageViewerPage(url: url)));
    return;
  }

  final urlToLoad = isPdf
      ? 'https://docs.google.com/gview?embedded=1&url=${Uri.encodeFull(url)}'
      : url;

  Navigator.push(context,
      MaterialPageRoute(builder: (_) => InAppWebViewPage(url: urlToLoad)));
}

Widget buildFileIcon(String filePath) {
  return Image.asset(
    getIconAssetForFileType(getFileType(filePath)),
    width: 35,
    height: 35,
    fit: BoxFit.contain,
  );
}
