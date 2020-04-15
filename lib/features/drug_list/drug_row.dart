import 'package:flutter/material.dart';

import 'drug_list_item.dart';

class DrugRow extends StatelessWidget {
  final DrugItem item;

  const DrugRow({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey,
            ),
          ],
        ),
        child: Center(
          child: Text(item.name),
        ),
      ),
    );
  }
}
