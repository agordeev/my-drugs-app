import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_drugs/shared/painters/screen_mode_button_painter.dart';

class SwitchScreenModeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Animation<double> animation;
  final EdgeInsets padding;

  final double _size = 24.0;

  const SwitchScreenModeButton({
    Key key,
    @required this.onPressed,
    @required this.animation,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final theme = Theme.of(context);

    final effectiveVisualDensity = theme.visualDensity;

    final unadjustedConstraints = const BoxConstraints(
      minWidth: kMinInteractiveDimension,
      minHeight: kMinInteractiveDimension,
    );
    final adjustedConstraints =
        effectiveVisualDensity.effectiveConstraints(unadjustedConstraints);

    Widget result = ConstrainedBox(
      constraints: adjustedConstraints,
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: _size,
          width: _size,
          child: Center(
            child: CustomPaint(
              size: Size(_size, _size),
              painter: ScreenModeButtonPainter(
                Theme.of(context).colorScheme.primary,
                animation,
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: true,
      child: InkResponse(
        canRequestFocus: true,
        onTap: onPressed,
        child: result,
        highlightColor: Theme.of(context).platform == TargetPlatform.iOS
            ? Colors.transparent
            : Theme.of(context).highlightColor,
        focusColor: Theme.of(context).platform == TargetPlatform.iOS
            ? Colors.transparent
            : Theme.of(context).focusColor,
        splashColor: Theme.of(context).platform == TargetPlatform.iOS
            ? Colors.transparent
            : Theme.of(context).splashColor,
        radius: math.max(
          Material.defaultSplashRadius,
          (_size + math.min(padding.horizontal, padding.vertical)) * 0.7,
          // x 0.5 for diameter -> radius and + 40% overflow derived from other Material apps.
        ),
      ),
    );
  }
}
