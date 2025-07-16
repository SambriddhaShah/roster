// full_screen_image_viewer.dart

import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final File imageFile;

  const FullScreenImageViewer({Key? key, required this.imageFile})
      : super(key: key);

  static void show(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => FullScreenImageViewer(imageFile: imageFile),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1.0,
              maxScale: 4.0,
              child: Image.file(imageFile, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 32,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
