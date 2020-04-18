import 'package:flutter/material.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';

import 'drug_list_row.dart';

class DrugHeadingRow extends DrugListRow {
  final DrugHeadingItem item;

  DrugHeadingRow({
    @required bool isInEditMode,
    @required this.item,
    @required AnimationController editModeAnimationController,
  }) : super(
          key: item.key,
          isInEditMode: isInEditMode,
          editModeAnimationController: editModeAnimationController,
        );

  @override
  State<StatefulWidget> createState() => DrugHeadingRowState();
}

class DrugHeadingRowState extends DrugListRowState<DrugHeadingRow> {
  @override
  Widget buildScaffold(BuildContext context, Widget animatedChild) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: animatedChild,
    );
  }

  /// Group name block.
  @override
  Widget buildDynamicContent(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.item.name,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFBABABA),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget buildStaticContent(BuildContext context) => Container();
}
