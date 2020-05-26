// import 'package:flutter/material.dart';
// import 'package:my_drugs/app/features/drug_list/bloc/drug_list_bloc.dart';
// import 'package:my_drugs/app/features/drug_list/models/drug_item.dart';
// import 'package:my_drugs/app/features/drug_list/models/selectable.dart';
// import 'package:my_drugs/app/features/drug_list/widgets/drug_heading_row_widget.dart';
// import 'package:my_drugs/models/drug.dart';

class DrugItemGroup {}

// /// A group of [DrugItem].
// class DrugItemGroup extends Selectable {
//   final GlobalKey<DrugHeadingRowState> key;
//   final GlobalKey<AnimatedListState> listKey;
//   final String name;
//   final List<DrugItem> items;
//   final bool isExpired;
//   final AnimatedListState state;

//   @override
//   AnimationController get checkmarkAnimationController =>
//       key.currentState.checkmarkAnimationController;

//   final _defaultAnimationDuration = Duration(milliseconds: 300);
//   final _searchAnimationDuration = Duration(milliseconds: 100);

//   /// Return [true] if all the [items] are selected.
//   bool get areAllItemsSelected =>
//       items.length == items.where((item) => item.isSelected).length;

//   List<String> get selectedItemsIds =>
//       items.where((e) => e.isSelected).map((e) => e.drug.id).toList();

//   DrugItemGroup(
//     this.key,
//     this.listKey,
//     this.name,
//     this.items,
//     this.isExpired,
//   ) : state = listKey.currentState;

//   void removeItem(
//     DrugItem item,
//     AnimatedListRemovedItemBuilder itemBuilder,
//   ) {
//     final index = items.indexOf(item);
//     if (index > -1) {
//       items.removeAt(index);
//       listKey.currentState.removeItem(
//         index,
//         itemBuilder,
//         duration: _defaultAnimationDuration,
//       );
//     }
//   }

//   void removeSelectedItems(
//       Widget Function(BuildContext, DrugItem, Animation<double>) itemBuilder) {
//     var selectedItemsCount = items.where((item) => item.isSelected).length;
//     while (selectedItemsCount > 0) {
//       final index = items.indexWhere((item) => item.isSelected);
//       final item = items.removeAt(index);
//       listKey.currentState.removeItem(
//         index,
//         (context, animation) => itemBuilder(context, item, animation),
//         duration: _defaultAnimationDuration,
//       );
//       selectedItemsCount -= 1;
//     }
//   }

//   /// Set [isSelected] property for each item from [items] so it's equal to [this.isSelected].
//   /// Calles when the user selects/deselects the entire group.
//   void updateItemsSelection() {
//     items.forEach((item) => item.toggleSelection(isSelected));
//   }

//   /// [filteredDrugs] - a list of filtered drugs for this group.
//   void filterItems(
//     List<Drug> filteredDrugs,
//     Widget Function(BuildContext, DrugItemGroup, DrugItem, Animation<double>)
//         itemBuilder,
//   ) {
//     if (listKey.currentState == null) {
//       return;
//     }
//     final idsToRemove = <String>[];
//     final drugsToAdd = <Drug>[];
//     final itemsIds = items.map((e) => e.drug.id).toList();
//     final filteredDrugsIds = filteredDrugs.map((e) => e.id).toList();
//     for (var item in items) {
//       if (!filteredDrugsIds.contains(item.drug.id)) {
//         idsToRemove.add(item.drug.id);
//       }
//     }
//     for (var drug in filteredDrugs) {
//       if (!itemsIds.contains(drug.id)) {
//         drugsToAdd.add(drug);
//       }
//     }

//     for (var id in idsToRemove) {
//       final index = items.indexWhere((item) => item.drug.id == id);
//       if (index > -1) {
//         final item = items.removeAt(index);
//         listKey.currentState.removeItem(
//           index,
//           (context, animation) => itemBuilder(context, this, item, animation),
//           duration: _searchAnimationDuration,
//         );
//       }
//     }

//     for (var drug in drugsToAdd) {
//       final itemToAdd = DrugItem(
//         GlobalKey(),
//         drug,
//         expiresOnDateFormat.format(drug.expiresOn),
//         true,
//       );
//       // Find the first index of item that needs to be displayed above [itemToAdd].
//       var indexToInsert =
//           items.indexWhere((item) => item.compareTo(itemToAdd) == 1);
//       if (indexToInsert == -1) {
//         // If there's no such item, [itemToAdd] needs to be the top item.
//         indexToInsert = items.length;
//       }
//       items.insert(indexToInsert, itemToAdd);
//       listKey.currentState.insertItem(
//         indexToInsert,
//         duration: _searchAnimationDuration,
//       );
//     }
//   }
// }
