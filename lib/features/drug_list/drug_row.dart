import 'package:flutter/material.dart';

import '../../shared/circle_painter.dart';
import 'drug_list_item.dart';

class DrugRow extends StatelessWidget {
  final DrugItem item;
  final AnimationController animationController;
  final double width;
  final double _expiresOnWidth = 90;
  final Animation<double> _checkmarkOpacity;
  final Animation<EdgeInsets> _textPadding;
  final Animation<EdgeInsets> _checkmarkPadding;

  DrugRow({
    Key key,
    @required this.item,
    @required this.animationController,
    @required this.width,
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
          begin: EdgeInsets.only(left: 16.0),
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
            // reverseCurve:
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final animatedChild = AnimatedBuilder(
      builder: _buildAnimation,
      animation: animationController,
      child: _buildExpiresOn(context),
    );
    return _buildScaffold(
      context,
      animatedChild,
    );
  }

  Widget _buildExpiresOn(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 16,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0), Colors.white],
                stops: [0.0, 1.0],
              )),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            width: _expiresOnWidth,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'EXPIRES ON',
                  style: TextStyle(
                    color: Color(0xFFBABABA),
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  item.expiresOn,
                  style: TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, Widget animatedChild) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0xFFD7D7D7),
            ),
          ],
        ),
        child: animatedChild,
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    final textWidth = width - (_expiresOnWidth + 16 + 16 + 8);
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
            child: Container(
              width: textWidth,
              child: Text(
                item.name,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        child,
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
