import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_row_item.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_heading_row_widget.dart';

class DrugListHeadingItem extends DrugListItem {
  final GlobalKey<DrugHeadingRowState> key;
  final String name;
  List<DrugListRowItem> items;

  bool get areAllItemsSelected => items.indexWhere((e) => !e.isSelected) == -1;

  @override
  AnimationController get checkmarkAnimationController =>
      key.currentState?.checkmarkAnimationController;

  DrugListHeadingItem({
    this.name,
  })  : key = GlobalKey(debugLabel: name),
        // TODO: Refactor
        super(id: 'heading$name');

  @override
  Widget build(
    BuildContext context,
    Animation<double> editModeAnimation,
  ) {
    return DrugHeadingRowWidget(
      key: key,
      group: this,
      isSelected: isSelected,
      editModeAnimation: editModeAnimation,
    );
  }
}
