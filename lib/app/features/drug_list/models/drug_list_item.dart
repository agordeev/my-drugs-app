import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/models/selectable.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_heading_row_widget.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_item_widget.dart';

abstract class DrugListItem extends Selectable {
  final id;

  DrugListItem(this.id, bool isSelected) : super(isSelected);

  Widget build(
    BuildContext context,
    Animation<double> editModeAnimation,
  );
}

class DrugListHeadingItem extends DrugListItem {
  final GlobalKey<DrugHeadingRowState> key;
  final String name;
  @override
  AnimationController get checkmarkAnimationController =>
      key.currentState.checkmarkAnimationController;

  DrugListHeadingItem(this.name, bool isSelected)
      : key = GlobalKey(),
        // TODO: Refactor
        super('heading$name', isSelected);

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

class DrugListRowItem extends DrugListItem {
  final GlobalKey<DrugItemRowState> key;
  final String name;
  final String formattedExpiresOn;
  final bool isExpired;
  @override
  AnimationController get checkmarkAnimationController =>
      key.currentState.checkmarkAnimationController;

  DrugListRowItem(
    String id,
    this.name,
    this.formattedExpiresOn,
    this.isExpired,
    bool isSelected,
  )   : key = GlobalKey(),
        super(id, isSelected);

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
