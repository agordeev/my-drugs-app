import 'dart:ui';

import 'package:flutter/material.dart';

class Checkmark extends StatelessWidget {
  final AnimationController animationController;

  const Checkmark({Key key, @required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: CheckmarkPainter(
          Theme.of(context).colorScheme.primary,
          animationController,
        ),
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final Color color;
  final Animation<double> _strokeWidth;
  final Animation<double> _checkmarkProgress;
  final Animation<double> _innerCircleOpacity;
  final Animation<double> _checkmarkOpacity;

  CheckmarkPainter(this.color, AnimationController animationController)
      : _strokeWidth = Tween<double>(
          begin: 2.0,
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
      ..color = Colors.grey[350]
      ..strokeWidth = _strokeWidth.value
      ..style = PaintingStyle.stroke;
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      strokePaint,
    );
    final fillPaint = Paint()
      ..color = Colors.grey[200].withOpacity(_innerCircleOpacity.value)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      fillPaint,
    );
    final path = Path()
      ..moveTo(0.27 * size.width, 0.45 * size.height)
      ..lineTo(0.47 * size.width, 0.64 * size.height)
      ..lineTo(0.72 * size.width, 0.33 * size.height);
    checkmarkPaint.color = color.withOpacity(_checkmarkOpacity.value);
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

    final path = new Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

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
