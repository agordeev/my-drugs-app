import 'package:flutter/material.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_group_item_widget.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_group_widget.dart';

abstract class DrugListItem {
  Widget build(BuildContext context, bool isInEditMode,
      AnimationController editModeAnimationController);
}

class DrugGroup implements DrugListItem {
  final GlobalKey<DrugHeadingRowState> key;
  final String name;
  final List<DrugGroupItem> items;

  DrugGroup(this.key, this.name, this.items);

  @override
  Widget build(BuildContext context, bool isInEditMode,
      AnimationController editModeAnimationController) {
    return DrugGroupWidget(
      item: this,
      isInEditMode: isInEditMode,
      editModeAnimationController: editModeAnimationController,
    );
  }
}

class DrugGroupItem implements DrugListItem {
  final GlobalKey<DrugItemRowState> key;
  final GlobalKey<DrugHeadingRowState> groupKey;
  final String id;
  final String name;
  final String expiresOn;

  DrugGroupItem(this.key, this.groupKey, this.id, this.name, this.expiresOn);

  @override
  Widget build(BuildContext context, bool isInEditMode,
      AnimationController editModeAnimationController) {
    return DrugGroupItemWidget(
      item: this,
      isInEditMode: isInEditMode,
      editModeAnimationController: editModeAnimationController,
    );
  }
}
