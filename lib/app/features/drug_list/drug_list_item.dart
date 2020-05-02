import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_group_item_widget.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_heading_row_widget.dart';

class DrugGroup {
  final GlobalKey<DrugHeadingRowState> key;
  final GlobalKey<AnimatedListState> listKey;
  final String name;
  final List<DrugGroupItem> items;
  bool isSelected;

  DrugGroup(
    this.key,
    this.listKey,
    this.name,
    this.items,
    this.isSelected,
  );
}

class DrugGroupItem {
  final GlobalKey<DrugItemRowState> key;
  final GlobalKey<DrugHeadingRowState> groupKey;
  final String id;
  final String name;
  final String expiresOn;
  bool isSelected;

  DrugGroupItem(
    this.key,
    this.groupKey,
    this.id,
    this.name,
    this.expiresOn,
    this.isSelected,
  );
}
