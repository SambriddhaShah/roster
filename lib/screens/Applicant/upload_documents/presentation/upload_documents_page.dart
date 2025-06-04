import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_event.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_state.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/file_upload_title.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class UploadDocumentsPage extends StatefulWidget {
  const UploadDocumentsPage({Key? key}) : super(key: key);

  @override
  State<UploadDocumentsPage> createState() => _UploadDocumentsPageState();
}

class _UploadDocumentsPageState extends State<UploadDocumentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<UploadBloc>().add(LoadInitialFiles());
  }

 void _pickFile(BuildContext context, String type) async {
    if (type == "photo") {
      final ImagePicker picker = ImagePicker();

      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Photo"),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source != null) {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          final file = File(image.path);
          context.read<UploadBloc>().add(FileSelected("photo", [file]));
        }
      }
    } else {
      // default file_picker for other types
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: type == 'certificates',
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null) {
        final files = result.paths.map((p) => File(p!)).toList();
        context.read<UploadBloc>().add(FileSelected(type, files));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Documents")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<UploadBloc, UploadState>(
          listener: (context, state) {
            if (state.isSuccess) {
              ToastMessage.showMessage("Documents uploaded successfully!");
            } else if (state.error != null) {
              ToastMessage.showMessage(state.error!);
            }
          },
          builder: (context, state) {
            print(
                'the remote files: ${state.remoteCV.length}, ${state.remotePhoto.length}, ${state.remoteCoverLetter.length}, ${state.remoteCertificates.length}');
            return ListView(
              children: [
                const Text(
                  "Please upload the following documents:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                FileUploadTile(
                  title: "CV",
                  fileList: state.cv,
                  remoteFileList: state.remoteCV,
                  onPressed: () => _pickFile(context, "cv"),
                ),
                FileUploadTile(
                  title: "Photo",
                  fileList: state.photo,
                  remoteFileList: state.remotePhoto,
                  onPressed: () => _pickFile(context, "photo"),
                ),
                FileUploadTile(
                  title: "Cover Letter",
                  fileList: state.coverLetter,
                  remoteFileList: state.remoteCoverLetter,
                  onPressed: () => _pickFile(context, "coverLetter"),
                ),
                FileUploadTile(
                  title: "Certificates",
                  fileList: state.certificates,
                  remoteFileList: state.remoteCertificates,
                  onPressed: () => _pickFile(context, "certificates"),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: state.isAllValid
                      ? () => context.read<UploadBloc>().add(SubmitDocuments())
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
