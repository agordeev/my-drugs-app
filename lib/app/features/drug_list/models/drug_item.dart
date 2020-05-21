import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/models/selectable.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_item_widget.dart';

class DrugItem extends Selectable {
  final GlobalKey<DrugItemRowState> key;
  final String id;
  final String name;
  final String expiresOn;
  final bool isExpired;

  @override
  AnimationController get checkmarkAnimationController =>
      key.currentState.checkmarkAnimationController;

  DrugItem(
    this.key,
    this.id,
    this.name,
    this.expiresOn,
    this.isExpired,
  );
}
