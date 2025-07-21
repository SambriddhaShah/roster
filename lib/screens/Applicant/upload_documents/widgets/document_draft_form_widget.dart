// // // document_draft_form_widget.dart

// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:rooster_empployee/screens/Applicant/upload_documents/model/full_screen_image_viewer.dart';

// // class DocumentDraftFormWidget extends StatelessWidget {
// //   final int index;
// //   final String name;
// //   final File? file;
// //   final bool isPhoto;
// //   final Function(String) onNameChanged;
// //   final Function(File, bool) onFileSelected;
// //   final VoidCallback onRemove;

// //   const DocumentDraftFormWidget({
// //     Key? key,
// //     required this.index,
// //     required this.name,
// //     required this.file,
// //     required this.isPhoto,
// //     required this.onNameChanged,
// //     required this.onFileSelected,
// //     required this.onRemove,
// //   }) : super(key: key);

// //   Future<void> _pickFile(BuildContext context) async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles(
// //       type: FileType.custom,
// //       allowedExtensions: ['pdf', 'doc', 'docx'],
// //     );

// //     if (result != null && result.files.single.path != null) {
// //       onFileSelected(File(result.files.single.path!), false);
// //     }
// //   }

// // // Add this helper method
// //   Future<void> _pickImage(BuildContext context, ImageSource source) async {
// //     final ImagePicker picker = ImagePicker();
// //     final XFile? image =
// //         await picker.pickImage(source: source, imageQuality: 70);
// //     if (image != null) {
// //       onFileSelected(File(image.path), true);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isTablet = MediaQuery.of(context).size.width >= 600;

// //     return Card(
// //       margin: const EdgeInsets.symmetric(vertical: 16),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       elevation: 3,
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             /// Name input
// //             TextFormField(
// //               initialValue: name,
// //               decoration: const InputDecoration(
// //                 labelText: 'Document Name',
// //                 border: OutlineInputBorder(),
// //               ),
// //               onChanged: onNameChanged,
// //             ),
// //             const SizedBox(height: 20),

// //             /// File selector
// //             if (file == null) ...[
// //               /// File selector
// //               GestureDetector(
// //                 onTap: () => _pickFile(context),
// //                 child: Container(
// //                   height: 120,
// //                   width: double.infinity,
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey.shade100,
// //                     border: Border.all(
// //                       color: Colors.green.shade400,
// //                       width: 1.5,
// //                     ),
// //                     borderRadius: BorderRadius.circular(16),
// //                   ),
// //                   child: const Center(
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Icon(Icons.insert_drive_file,
// //                             size: 30, color: Colors.grey),
// //                         SizedBox(height: 8),
// //                         Text("Select file",
// //                             style: TextStyle(color: Colors.grey)),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),

// //               /// OR separator
// //               Row(
// //                 children: const [
// //                   Expanded(child: Divider()),
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 12),
// //                     child: Text("or"),
// //                   ),
// //                   Expanded(child: Divider()),
// //                 ],
// //               ),

// //               const SizedBox(height: 12),

// //               /// Photo options: Camera & Gallery
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Expanded(
// //                     child: ElevatedButton.icon(
// //                       onPressed: () => _pickImage(context, ImageSource.camera),
// //                       icon: const Icon(Icons.camera_alt),
// //                       label: const Text("Take Photo"),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.green.shade50,
// //                         foregroundColor: Colors.green.shade700,
// //                         elevation: 0,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(32),
// //                         ),
// //                         padding: const EdgeInsets.symmetric(vertical: 14),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: ElevatedButton.icon(
// //                       onPressed: () => _pickImage(context, ImageSource.gallery),
// //                       icon: const Icon(Icons.photo_library),
// //                       label: const Text("Gallery"),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.green.shade50,
// //                         foregroundColor: Colors.green.shade700,
// //                         elevation: 0,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(32),
// //                         ),
// //                         padding: const EdgeInsets.symmetric(vertical: 14),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ] else ...[
// //               /// File Preview (file already selected)
// //               Container(
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade50,
// //                   borderRadius: BorderRadius.circular(8),
// //                   border: Border.all(color: Colors.grey.shade300),
// //                 ),
// //                 padding:
// //                     const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
// //                 child: Row(
// //                   children: [
// //                     isPhoto
// //                         ? GestureDetector(
// //                             onTap: () =>
// //                                 FullScreenImageViewer.show(context, file!),
// //                             child: ClipRRect(
// //                               borderRadius: BorderRadius.circular(8),
// //                               child: Image.file(
// //                                 file!,
// //                                 height: 48,
// //                                 width: 48,
// //                                 fit: BoxFit.cover,
// //                               ),
// //                             ),
// //                           )
// //                         : const Icon(Icons.insert_drive_file,
// //                             color: Colors.blueGrey),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Text(
// //                         file!.path.split('/').last,
// //                         style: const TextStyle(fontSize: 14),
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ),
// //                     IconButton(
// //                       onPressed: onRemove,
// //                       icon: const Icon(Icons.delete_forever, color: Colors.red),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ]
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:rooster_empployee/constants/appColors.dart';
// import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/full_screen_image_viewer.dart';

// class DocumentDraftFormWidget extends StatelessWidget {
//   final int index;
//   final String name;
//   final File? file;
//   final bool isPhoto;
//   final Function(String) onNameChanged;
//   final Function(File, bool) onFileSelected;
//   final VoidCallback onRemove;
//   final bool isSubmitting;
//   final VoidCallback onSubmit;
//   final VoidCallback onCancel;

//   const DocumentDraftFormWidget({
//     Key? key,
//     required this.index,
//     required this.name,
//     required this.file,
//     required this.isPhoto,
//     required this.onNameChanged,
//     required this.onFileSelected,
//     required this.onRemove,
//     required this.isSubmitting,
//     required this.onSubmit,
//     required this.onCancel,
//   }) : super(key: key);

//   Future<void> _pickFile(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );

//     if (result != null && result.files.single.path != null) {
//       onFileSelected(File(result.files.single.path!), false);
//     }
//   }

//   Future<void> _pickImage(BuildContext context, ImageSource source) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image =
//         await picker.pickImage(source: source, imageQuality: 70);
//     if (image != null) {
//       onFileSelected(File(image.path), true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isTablet = MediaQuery.of(context).size.width >= 600;

//     return Card(
//       color: AppColors.surface,
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Name input
//             TextFormField(
//               initialValue: name,
//               decoration: const InputDecoration(
//                 labelText: 'Document Name',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: onNameChanged,
//             ),
//             const SizedBox(height: 20),

//             /// Animated file/photo picker or preview
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               transitionBuilder: (child, animation) =>
//                   FadeTransition(opacity: animation, child: child),
//               child: file == null
//                   ? _buildPickerSection(context)
//                   : _buildPreviewSection(context),
//             ),
//             const SizedBox(height: 20),

//             /// Action buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: isSubmitting
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Icon(Icons.cloud_upload),
//                     label: const Text("Submit"),
//                     onPressed: (file != null &&
//                             name.trim().isNotEmpty &&
//                             !isSubmitting)
//                         ? onSubmit
//                         : null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.cancel),
//                     label: const Text("Cancel"),
//                     onPressed: onCancel,
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.red,
//                       side: const BorderSide(color: Colors.red),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// File/photo selection UI
//   Widget _buildPickerSection(BuildContext context) {
//     return Column(
//       key: const ValueKey('picker'),
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: () => _pickFile(context),
//           child: Container(
//             height: 120,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               border: Border.all(
//                 color: Colors.green.shade400,
//                 width: 1.5,
//               ),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.insert_drive_file, size: 30, color: Colors.grey),
//                   SizedBox(height: 8),
//                   Text("Select file", style: TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),

//         /// OR separator
//         Row(
//           children: const [
//             Expanded(child: Divider()),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: Text("or"),
//             ),
//             Expanded(child: Divider()),
//           ],
//         ),
//         const SizedBox(height: 12),

//         /// Camera and Gallery buttons
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: () => _pickImage(context, ImageSource.camera),
//                 icon: const Icon(Icons.camera_alt),
//                 label: const Text("Take Photo"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade50,
//                   foregroundColor: Colors.green.shade700,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(32),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: () => _pickImage(context, ImageSource.gallery),
//                 icon: const Icon(Icons.photo_library),
//                 label: const Text("Gallery"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade50,
//                   foregroundColor: Colors.green.shade700,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(32),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   /// File or photo preview UI
//   Widget _buildPreviewSection(BuildContext context) {
//     return Container(
//       key: const ValueKey('preview'),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       child: Row(
//         children: [
//           isPhoto
//               ? GestureDetector(
//                   onTap: () => FullScreenImageViewer.show(context, file!),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.file(
//                       file!,
//                       height: 48,
//                       width: 48,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 )
//               : const Icon(Icons.insert_drive_file, color: Colors.blueGrey),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               file!.path.split('/').last,
//               style: const TextStyle(fontSize: 14),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           IconButton(
//             onPressed: onRemove,
//             icon: const Icon(Icons.delete_forever, color: Colors.red),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/full_screen_image_viewer.dart';

class DocumentDraftFormWidget extends StatelessWidget {
  final int index;
  final String name;
  final File? file;
  final bool isPhoto;
  final Function(String) onNameChanged;
  final Function(File, bool) onFileSelected;
  final VoidCallback onRemove;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const DocumentDraftFormWidget({
    Key? key,
    required this.index,
    required this.name,
    required this.file,
    required this.isPhoto,
    required this.onNameChanged,
    required this.onFileSelected,
    required this.onRemove,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onCancel,
  }) : super(key: key);

  Future<void> _pickFile(BuildContext context) async {
    if (isSubmitting) return;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      onFileSelected(File(result.files.single.path!), false);
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    if (isSubmitting) return;
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      onFileSelected(File(image.path), true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Document",
                  style: AppTextStyles.headline3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// Name input
            TextFormField(
              initialValue: name,
              enabled: !isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Document Name',
                border: OutlineInputBorder(),
              ),
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 20),

            /// File/photo section
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: file == null
                  ? _buildPickerSection(context)
                  : _buildPreviewSection(context),
            ),

            const SizedBox(height: 20),

            /// Submit & Cancel buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.cloud_upload),
                    label: const Text("Submit"),
                    onPressed: (file != null &&
                            name.trim().isNotEmpty &&
                            !isSubmitting)
                        ? onSubmit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("Cancel"),
                    onPressed: isSubmitting ? null : onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// File/photo picker section
  Widget _buildPickerSection(BuildContext context) {
    return Column(
      key: const ValueKey('picker'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickFile(context),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                color: Colors.green.shade400,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insert_drive_file, size: 30, color: Colors.grey),
                  SizedBox(height: 8),
                  Text("Select file", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("or"),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isSubmitting
                    ? null
                    : () => _pickImage(context, ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Take Photo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade700,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isSubmitting
                    ? null
                    : () => _pickImage(context, ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text("Gallery"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade700,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Preview for selected file or photo
  Widget _buildPreviewSection(BuildContext context) {
    return Container(
      key: const ValueKey('preview'),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          isPhoto
              ? GestureDetector(
                  onTap: () => FullScreenImageViewer.show(context, file!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file!,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    OpenFilex.open(file!.path);
                  },
                  child: const Icon(Icons.insert_drive_file,
                      color: Colors.blueGrey),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file!.path.split('/').last,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: isSubmitting ? null : onRemove,
            icon: const Icon(Icons.delete_forever, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
