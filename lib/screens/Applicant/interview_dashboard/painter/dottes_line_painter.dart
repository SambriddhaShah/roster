import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final double height;
  final Color color;

  DottedLinePainter({required this.height, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double dashHeight = 4;
    const double dashSpace = 4;
    double startY = 0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    while (startY < height) {
      canvas.drawLine(
        const Offset(0, 0) + Offset(0, startY),
        const Offset(0, 0) + Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DottedLinePainter oldDelegate) {
    return oldDelegate.height != height || oldDelegate.color != color;
  }
}
