import 'package:flutter/material.dart';

/// Draws a circle if placed into a square widget.
class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.grey[350]
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
