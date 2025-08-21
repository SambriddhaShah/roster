import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget {
  final String url;
  const ImageViewerPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Viewer'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.network(
            url,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : const CircularProgressIndicator(),
            errorBuilder: (_, __, ___) => const Text('Failed to load image',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
