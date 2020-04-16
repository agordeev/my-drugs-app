import 'package:flutter/material.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/shared/circle_painter.dart';

class DrugHeading extends StatelessWidget {
  final DrugHeadingItem item;
  final AnimationController animationController;
  final Animation<double> _checkmarkOpacity;
  final Animation<EdgeInsets> _textPadding;
  final Animation<EdgeInsets> _checkmarkPadding;

  DrugHeading({
    Key key,
    @required this.item,
    @required this.animationController,
  })  : _checkmarkOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              0.2,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        _textPadding = Tween<EdgeInsets>(
          begin: EdgeInsets.only(left: 0),
          end: EdgeInsets.only(left: 36.0),
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
        ),
        _checkmarkPadding = Tween<EdgeInsets>(
          begin: EdgeInsets.zero,
          end: EdgeInsets.only(left: 8.0),
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: AnimatedBuilder(
        builder: _buildAnimation,
        animation: animationController,
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: _checkmarkPadding.value,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: _checkmarkOpacity.value,
              child: _buildCheckmark(context),
            ),
          ),
        ),
        Padding(
          padding: _textPadding.value,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFBABABA),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckmark(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: CirclePainter(),
      ),
    );
  }
}
