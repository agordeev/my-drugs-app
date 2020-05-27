// TODO: Remove
// import 'package:flutter/material.dart';
// import 'package:my_drugs/app/features/drug_list/models/selectable.dart';
// import 'package:my_drugs/app/features/drug_list/widgets/drug_item_widget.dart';
// import 'package:my_drugs/models/drug.dart';

// class DrugItem extends Selectable implements Comparable {
//   final GlobalKey<DrugItemRowState> key;
//   final Drug drug;
//   final String formattedExpiresOn;
//   final bool isExpired;

//   @override
//   AnimationController get checkmarkAnimationController =>
//       key.currentState.checkmarkAnimationController;

//   DrugItem(
//     this.key,
//     this.drug,
//     this.formattedExpiresOn,
//     this.isExpired,
//   );

//   @override
//   int compareTo(other) {
//     if (other is DrugItem) {
//       return drug.compareTo(other.drug);
//     } else {
//       return 0;
//     }
//   }
// }
