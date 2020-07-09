import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_heading_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_item.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_item_widget.dart';

class DrugListRowItem extends DrugListItem {
  final DrugListHeadingItem group;
  final GlobalKey<DrugItemRowState> key;
  final String name;
  final String formattedExpiresOn;
  final bool isExpired;

  @override
  AnimationController get checkmarkAnimationController =>
      key.currentState?.checkmarkAnimationController;

  DrugListRowItem({
    this.group,
    String id,
    this.name,
    this.formattedExpiresOn,
    this.isExpired,
  })  : key = GlobalKey(debugLabel: id),
        super(id: id);

  @override
  Widget build(
    BuildContext context,
    Animation<double> editModeAnimation,
  ) {
    return DrugItemWidget(
      key: key,
      item: this,
      isSelected: isSelected,
      editModeAnimation: editModeAnimation,
    );
  }
}
