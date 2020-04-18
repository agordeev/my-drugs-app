import 'package:flutter/material.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_heading_row.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_item_row.dart';

abstract class DrugListItem {}

class DrugHeadingItem extends DrugListItem {
  final GlobalKey<DrugHeadingRowState> key;
  final String name;

  DrugHeadingItem(
    this.key,
    this.name,
  );
}

class DrugItem extends DrugListItem {
  final GlobalKey<DrugItemRowState> key;
  final String id;
  final String name;
  final String expiresOn;

  DrugItem(
    this.key,
    this.id,
    this.name,
    this.expiresOn,
  );
}
