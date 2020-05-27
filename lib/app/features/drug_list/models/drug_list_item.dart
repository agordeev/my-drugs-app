import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/models/selectable.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_heading_row_widget.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_item_widget.dart';

abstract class DrugListItem extends Selectable {
  final String id;

  DrugListItem({this.id});

  Widget build(
    BuildContext context,
    Animation<double> editModeAnimation,
  );
}

// TODO: Move to separate file
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

// TODO: Move to separate file
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
