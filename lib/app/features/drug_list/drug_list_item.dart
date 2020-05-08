import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_group_item_widget.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_heading_row_widget.dart';

class DrugGroup {
  final GlobalKey<DrugHeadingRowState> key;
  final GlobalKey<AnimatedListState> listKey;
  final String name;
  final List<DrugGroupItem> items;
  final bool isExpired;
  bool isSelected;

  DrugGroup(
    this.key,
    this.listKey,
    this.name,
    this.items,
    this.isExpired,
    this.isSelected,
  );
}

class DrugGroupItem {
  final GlobalKey<DrugItemRowState> key;
  final GlobalKey<DrugHeadingRowState> groupKey;
  final String id;
  final String name;
  final String expiresOn;
  final bool isExpired;
  bool isSelected;

  DrugGroupItem(
    this.key,
    this.groupKey,
    this.id,
    this.name,
    this.expiresOn,
    this.isExpired,
    this.isSelected,
  );
}
