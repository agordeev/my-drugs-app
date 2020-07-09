import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/models/selectable.dart';

abstract class DrugListItem extends Selectable {
  final String id;

  DrugListItem({this.id});

  Widget build(
    BuildContext context,
    Animation<double> editModeAnimation,
  );
}
