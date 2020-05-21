import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item.dart';
import 'package:my_drugs/app/features/drug_list/models/selectable.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_heading_row_widget.dart';

/// A group of [DrugItem].
class DrugItemGroup extends Selectable {
  final GlobalKey<DrugHeadingRowState> key;
  final GlobalKey<AnimatedListState> listKey;
  final String name;
  final List<DrugItem> items;
  final bool isExpired;

  @override
  AnimationController get checkmarkAnimationController =>
      key.currentState.checkmarkAnimationController;

  final _animationDuration = Duration(milliseconds: 300);

  /// Return [true] if all the [items] are selected.
  bool get areAllItemsSelected =>
      items.length == items.where((item) => item.isSelected).length;

  List<String> get selectedItemsIds =>
      items.where((e) => e.isSelected).map((e) => e.id);

  DrugItemGroup(
    this.key,
    this.listKey,
    this.name,
    this.items,
    this.isExpired,
  );

  void removeItem(
    DrugItem item,
    AnimatedListRemovedItemBuilder itemBuilder,
  ) {
    final index = items.indexOf(item);
    if (index > -1) {
      items.removeAt(index);
      listKey.currentState.removeItem(
        index,
        itemBuilder,
        duration: _animationDuration,
      );
    }
  }

  void removeSelectedItems(
      Widget Function(BuildContext, DrugItem, Animation<double>) itemBuilder) {
    var selectedItemsCount = items.where((item) => item.isSelected).length;
    while (selectedItemsCount > 0) {
      final index = items.indexWhere((item) => item.isSelected);
      final item = items.removeAt(index);
      listKey.currentState.removeItem(
        index,
        (context, animation) => itemBuilder(context, item, animation),
        duration: _animationDuration,
      );
      selectedItemsCount -= 1;
    }
  }

  /// Set [isSelected] property for each item from [items] so it's equal to [this.isSelected].
  /// Calles when the user selects/deselects the entire group.
  void updateItemsSelection() {
    items.forEach((item) => item.toggleSelection(isSelected));
  }
}
