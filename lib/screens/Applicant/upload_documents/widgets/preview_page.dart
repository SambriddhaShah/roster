import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:open_filex/open_filex.dart';
import 'package:mime/mime.dart';

class PreviewPage extends StatelessWidget {
  final File file;

  const PreviewPage({Key? key, required this.file}) : super(key: key);

  bool get isImage {
    final mime = lookupMimeType(file.path);
    return mime != null && mime.startsWith('image/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Preview")),
      body: isImage
          ? PhotoView(imageProvider: FileImage(file))
          : Center(
              child: ElevatedButton.icon(
                onPressed: () => OpenFilex.open(file.path),
                icon: const Icon(Icons.open_in_new),
                label: const Text("Open File"),
              ),
            ),
    );
  }
}
