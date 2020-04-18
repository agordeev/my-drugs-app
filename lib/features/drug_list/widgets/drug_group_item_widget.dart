import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_list_row.dart';

class DrugGroupItemWidget extends DrugListRow {
  final DrugGroupItem item;
  // A padding of parent widget. 16 by default.
  final double horizontalPadding = 16;

  DrugGroupItemWidget({
    @required this.item,
    @required bool isInEditMode,
    @required AnimationController editModeAnimationController,
  }) : super(
          key: item.key,
          isInEditMode: isInEditMode,
          editModeAnimationController: editModeAnimationController,
        );

  @override
  DrugListRowState createState() => DrugItemRowState();
}

class DrugItemRowState extends DrugListRowState<DrugGroupItemWidget> {
  final double _expiresOnWidth = 90;

  /// Drug name block.
  @override
  Widget buildDynamicContent(BuildContext context) {
    final widgetWidth =
        MediaQuery.of(context).size.width - widget.horizontalPadding * 2;
    final textWidth = widgetWidth - (_expiresOnWidth + 16 + 16 + 8);
    return Container(
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: textWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
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
    );
  }

  @override
  Widget buildScaffold(BuildContext context, Widget animatedChild) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: widget.isInEditMode
            ? () =>
                BlocProvider.of<DrugListBloc>(context).add(SelectDeselectDrug(
                  widget.item,
                ))
            : null,
        child: animatedChild,
      ),
    );
  }

  /// EXPIRES ON block.
  @override
  Widget buildStaticContent(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
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
}
