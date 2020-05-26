import 'package:flutter/material.dart';

import 'checkmark.dart';

abstract class DrugListRow extends StatefulWidget {
  /// Animation used to show/hide checkmark
  final Animation<double> editModeAnimation;
  final Animation<double> _checkmarkOpacity;
  final Animation<EdgeInsets> _checkmarkPadding;
  final Animation<EdgeInsets> _contentPadding;
  final bool isSelected;

  DrugListRow({
    Key key,
    @required this.isSelected,
    @required this.editModeAnimation,
  })  : _checkmarkOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: editModeAnimation,
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
            parent: editModeAnimation,
            curve: Curves.ease,
          ),
        ),
        _contentPadding = Tween<EdgeInsets>(
          begin: EdgeInsets.only(left: 8.0),
          end: EdgeInsets.only(left: 36.0),
        ).animate(
          CurvedAnimation(
            parent: editModeAnimation,
            curve: Curves.ease,
          ),
        ),
        super(key: key);
}

abstract class DrugListRowState<T extends DrugListRow> extends State<T>
    with SingleTickerProviderStateMixin {
  AnimationController checkmarkAnimationController;

  @override
  void initState() {
    checkmarkAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    checkmarkAnimationController.value = widget.isSelected ? 1.0 : 0.0;
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
      animation: widget.editModeAnimation,
      child: buildStaticContent(context),
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: buildScaffold(
        context,
        animatedChild,
      ),
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

  void onTap();
}
