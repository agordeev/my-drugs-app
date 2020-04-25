import 'package:flutter/material.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_group_item_widget.dart';

import 'drug_heading_row_widget.dart';

class DrugGroupWidget extends StatelessWidget {
  final DrugGroup group;
  final bool isInEditMode;
  final Animation<double> editModeAnimation;
  final Animation<double> listAnimation;
  final Function(DrugGroupItem) onPresentContextMenuTap;

  const DrugGroupWidget({
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
                return DrugGroupItemWidget(
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
