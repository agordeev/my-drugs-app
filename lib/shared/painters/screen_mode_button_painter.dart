import 'package:flutter/material.dart';

class ScreenModeButtonPainter extends CustomPainter {
  final Color color;
  final Animation<double> _dotOffsetFactor;
  final Animation<double> _linesLengthFactor;
  final Paint _paint;

  final double _radius = 3.0;

  ScreenModeButtonPainter(this.color, AnimationController animationController)
      : _paint = Paint()
          ..color = color
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.fill,
        _dotOffsetFactor = Tween<double>(
          begin: 0.25,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              0.0,
              0.5,
              curve: Curves.easeIn,
            ),
          ),
        ),
        _linesLengthFactor = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              0.5,
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        );

  @override
  void paint(Canvas canvas, Size size) {
    _paintDots(
      canvas,
      size,
    );
    _paintLines(
      canvas,
      size,
    );
  }

  void _paintDots(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(
        size.width * 0.5 - _dotOffsetFactor.value * size.width,
        size.height * 0.5,
      ),
      _radius,
      _paint,
    );
    canvas.drawCircle(
      Offset(
        size.width * 0.5 + _dotOffsetFactor.value * size.width,
        size.height * 0.5,
      ),
      _radius,
      _paint,
    );
    canvas.drawCircle(
      Offset(
        size.width * 0.5,
        size.height * 0.5,
      ),
      _radius,
      _paint,
    );
  }

  void _paintLines(Canvas canvas, Size size) {
    final changer = 0.3 * _linesLengthFactor.value;
    canvas.drawLine(
      Offset(
        size.width * (0.5 - changer),
        size.height * (0.5 - changer),
      ),
      Offset(
        size.width * (0.5 + changer),
        size.height * (0.5 + changer),
      ),
      _paint,
    );
    canvas.drawLine(
      Offset(
        size.width * (0.5 - changer),
        size.height * (0.5 + changer),
      ),
      Offset(
        size.width * (0.5 + changer),
        size.height * (0.5 - changer),
      ),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
