import 'package:flutter/material.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_heading_row.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_item_row.dart';

abstract class DrugListItem {
  final bool isExpired;

  DrugListItem(this.isExpired);
}

class DrugHeadingItem extends DrugListItem {
  final GlobalKey<DrugHeadingRowState> key;

  DrugHeadingItem(
    this.key,
    bool isExpired,
  ) : super(isExpired);
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
    bool isExpired,
  ) : super(isExpired);
}
