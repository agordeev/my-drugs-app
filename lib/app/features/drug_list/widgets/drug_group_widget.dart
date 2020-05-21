import 'package:flutter/material.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item_group.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_item_widget.dart';

import 'drug_heading_row_widget.dart';

class DrugItemGroupWidget extends StatelessWidget {
  final DrugItemGroup group;
  final bool isInEditMode;
  final Animation<double> editModeAnimation;
  final Animation<double> listAnimation;
  final Function(DrugItem) onPresentContextMenuTap;

  const DrugItemGroupWidget({
    Key key,
    @required this.group,
    @required this.isInEditMode,
    @required this.editModeAnimation,
    @required this.listAnimation,
    @required this.onPresentContextMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: listAnimation,
      child: FadeTransition(
        opacity: listAnimation,
        child: Column(
          children: <Widget>[
            DrugHeadingRowWidget(
              item: group,
              isInEditMode: isInEditMode,
              editModeAnimation: editModeAnimation,
            ),
            AnimatedList(
              key: group.listKey,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              initialItemCount: group.items.length,
              itemBuilder: (context, itemIndex, itemAnimation) {
                final item = group.items[itemIndex];
                return DrugItemWidget(
                  item: item,
                  isInEditMode: isInEditMode,
                  editModeAnimation: editModeAnimation,
                  animation: itemAnimation,
                  onPresentContextMenuTap: () => onPresentContextMenuTap(item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
