import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_list_row.dart';

class DrugItemRow extends DrugListRow {
  final DrugItem item;
  final double width;

  DrugItemRow({
    @required bool isInEditMode,
    @required this.item,
    @required AnimationController editModeAnimationController,
    @required this.width,
  }) : super(
          key: item.key,
          isInEditMode: isInEditMode,
          editModeAnimationController: editModeAnimationController,
        );

  @override
  DrugListRowState createState() => DrugItemRowState();
}

class DrugItemRowState extends DrugListRowState<DrugItemRow> {
  final double _expiresOnWidth = 90;

  /// Drug name block.
  @override
  Widget buildDynamicContent(BuildContext context) {
    final textWidth = widget.width - (_expiresOnWidth + 16 + 16 + 8);
    return Align(
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
    );
  }

  @override
  Widget buildScaffold(BuildContext context, Widget animatedChild) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: widget.isInEditMode
            ? () {
                isSelected = !isSelected;
                if (isSelected) {
                  checkmarkAnimationController.forward();
                } else {
                  checkmarkAnimationController.reverse();
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

  /// EXPIRES ON block.
  @override
  Widget buildStaticContent(BuildContext context) {
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
}
