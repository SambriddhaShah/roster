import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/widgets/preview_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/upload_bloc.dart';
import '../bloc/upload_event.dart';

class FileUploadTile extends StatelessWidget {
  final String title;
  final List<File> fileList;
  final List<RemoteFile> remoteFileList;
  final VoidCallback onPressed;

  const FileUploadTile({
    required this.title,
    required this.fileList,
    required this.remoteFileList,
    required this.onPressed,
    super.key,
  });

  bool _isImage(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType != null && mimeType.startsWith('image/');
  }

  void _previewFile(BuildContext context, File file) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PreviewPage(file: file)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: (fileList.isEmpty && remoteFileList.isEmpty)
            ? const Text("No file selected")
            : Text(
                "${fileList.length + remoteFileList.length} file(s) selected"),
        trailing: IconButton(
          icon: const Icon(Icons.attach_file),
          onPressed: onPressed,
        ),
        childrenPadding: const EdgeInsets.only(bottom: 12),
        children: [
          // 🔹 Remote Files
          ...remoteFileList.map((file) => ListTile(
                leading: _isImage(file.url)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(file.url,
                            width: 40, height: 40, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.cloud_done),
                title: Text(file.name),
                onTap: () async {
                  final uri = Uri.parse(file.url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cannot open file")),
                    );
                  }
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () {
                    final type = title.toLowerCase().replaceAll(' ', '');
                    context
                        .read<UploadBloc>()
                        .add(RemoveRemoteFile(type, file));
                  },
                ),
              )),

          // 🔹 Local Files
          ...fileList.map((file) {
            final isImg = _isImage(file.path);
            return ListTile(
              leading: isImg
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(file,
                          width: 40, height: 40, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.insert_drive_file),
              title: Text(file.path.split('/').last),
              onTap: () => _previewFile(context, file),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  final type = title.toLowerCase().replaceAll(' ', '');
                  context.read<UploadBloc>().add(RemoveFile(type, file));
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
