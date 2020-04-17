import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/features/drug_list/widgets/checkmark.dart';

class DrugRow extends StatefulWidget {
  final bool isInEditMode;
  final DrugItem item;
  final AnimationController animationController;
  final double width;
  final Animation<double> _checkmarkOpacity;
  final Animation<EdgeInsets> _textPadding;
  final Animation<EdgeInsets> _checkmarkPadding;

  DrugRow({
    Key key,
    @required this.isInEditMode,
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
          ),
        ),
        super(key: key);

  @override
  _DrugRowState createState() => _DrugRowState();
}

class _DrugRowState extends State<DrugRow> with SingleTickerProviderStateMixin {
  final double _expiresOnWidth = 90;
  bool isSelected = false;
  AnimationController _checkmarkAnimationController;

  @override
  void initState() {
    _checkmarkAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animatedChild = AnimatedBuilder(
      builder: _buildAnimation,
      animation: widget.animationController,
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
                  widget.item.expiresOn,
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
      child: InkWell(
        onTap: widget.isInEditMode
            ? () {
                isSelected = !isSelected;
                if (isSelected) {
                  _checkmarkAnimationController.forward();
                } else {
                  _checkmarkAnimationController.reverse();
                }
                BlocProvider.of<DrugListBloc>(context)
                    .add(SelectDeselectDrug(widget.item.id, isSelected));
              }
            : null,
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
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    final textWidth = widget.width - (_expiresOnWidth + 16 + 16 + 8);
    return Stack(
      children: <Widget>[
        Padding(
          padding: widget._checkmarkPadding.value,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: widget._checkmarkOpacity.value,
              child: Checkmark(
                animationController: _checkmarkAnimationController,
              ),
              // child: _buildCheckmark(context),
            ),
          ),
        ),
        Padding(
          padding: widget._textPadding.value,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: textWidth,
              child: Text(
                widget.item.name,
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
}
