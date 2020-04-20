import 'package:flutter/material.dart';

import 'checkmark.dart';

abstract class DrugListRow extends StatefulWidget {
  final bool isInEditMode;
  final AnimationController editModeAnimationController;
  final Animation<double> _checkmarkOpacity;
  final Animation<EdgeInsets> _checkmarkPadding;
  final Animation<EdgeInsets> _contentPadding;

  DrugListRow({
    Key key,
    @required this.isInEditMode,
    @required this.editModeAnimationController,
  })  : _checkmarkOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: editModeAnimationController,
            curve: Interval(
              0.2,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        _checkmarkPadding = Tween<EdgeInsets>(
          begin: EdgeInsets.zero,
          end: EdgeInsets.only(left: 4.0),
        ).animate(
          CurvedAnimation(
            parent: editModeAnimationController,
            curve: Curves.ease,
          ),
        ),
        _contentPadding = Tween<EdgeInsets>(
          begin: EdgeInsets.only(left: 8.0),
          end: EdgeInsets.only(left: 36.0),
        ).animate(
          CurvedAnimation(
            parent: editModeAnimationController,
            curve: Curves.ease,
          ),
        ),
        super(key: key);
}

abstract class DrugListRowState<T extends DrugListRow> extends State<T>
    with SingleTickerProviderStateMixin {
  bool isSelected = false;
  AnimationController checkmarkAnimationController;

  @override
  void initState() {
    checkmarkAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    checkmarkAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animatedChild = AnimatedBuilder(
      builder: buildAnimationStack,
      animation: widget.editModeAnimationController,
      child: buildStaticContent(context),
    );
    return buildScaffold(
      context,
      animatedChild,
    );
  }

  Widget buildScaffold(BuildContext context, Widget animatedChild);

  Widget buildAnimationStack(BuildContext context, Widget child) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Padding(
          padding: widget._checkmarkPadding.value,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: widget._checkmarkOpacity.value,
              child: Checkmark(
                animationController: checkmarkAnimationController,
              ),
              // child: _buildCheckmark(context),
            ),
          ),
        ),
        Padding(
          padding: widget._contentPadding.value,
          child: buildDynamicContent(context),
        ),
        child,
      ],
    );
  }

  Widget buildDynamicContent(BuildContext context);

  Widget buildStaticContent(BuildContext context);
}
