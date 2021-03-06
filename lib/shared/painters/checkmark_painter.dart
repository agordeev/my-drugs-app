import 'dart:ui';

import 'package:flutter/material.dart';

/// Draws a checkmark with animation.
class CheckmarkPainter extends CustomPainter {
  final Color color;
  final Animation<double> _strokeWidth;
  final Animation<double> _checkmarkProgress;
  final Animation<double> _innerCircleOpacity;
  final Animation<double> _checkmarkOpacity;

  CheckmarkPainter(this.color, AnimationController animationController)
      : _strokeWidth = Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        _checkmarkProgress = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              0.0,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        _innerCircleOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        _checkmarkOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              0.0,
              0.5,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        super(repaint: animationController);

  Paint checkmarkPaint = Paint()
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth.value
      ..style = PaintingStyle.stroke;
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      strokePaint,
    );
    final fillPaint = Paint()
      ..color = color.withOpacity(_innerCircleOpacity.value)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      fillPaint,
    );
    final path = Path()
      ..moveTo(0.27 * size.width, 0.45 * size.height)
      ..lineTo(0.47 * size.width, 0.64 * size.height)
      ..lineTo(0.72 * size.width, 0.33 * size.height);
    checkmarkPaint.color = Colors.white.withOpacity(_checkmarkOpacity.value);
    final animatedPath = createAnimatedPath(path, _checkmarkProgress.value);
    canvas.drawPath(animatedPath, checkmarkPaint);
  }

  Path createAnimatedPath(
    Path originalPath,
    double animationPercent,
  ) {
    final totalLength = originalPath
        .computeMetrics()
        .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    final currentLength = totalLength * animationPercent;

    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;

    final path = Path();

    final metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;

      final nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
