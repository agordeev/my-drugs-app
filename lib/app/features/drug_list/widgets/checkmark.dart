import 'package:flutter/material.dart';
import 'package:my_drugs/shared/painters/checkmark_painter.dart';

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
