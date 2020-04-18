import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';

import 'drug_list_row.dart';

class DrugGroupWidget extends DrugListRow {
  final DrugGroup item;

  DrugGroupWidget({
    @required bool isInEditMode,
    @required this.item,
    @required AnimationController editModeAnimationController,
  }) : super(
          key: item.key,
          isInEditMode: isInEditMode,
          editModeAnimationController: editModeAnimationController,
        );

  @override
  State<StatefulWidget> createState() => DrugHeadingRowState();
}

class DrugHeadingRowState extends DrugListRowState<DrugGroupWidget> {
  @override
  Widget buildScaffold(BuildContext context, Widget animatedChild) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: widget.isInEditMode
            ? () => BlocProvider.of<DrugListBloc>(context).add(
                  SelectDeselectGroup(
                    widget.item,
                  ),
                )
            : null,
        child: animatedChild,
      ),
    );
  }

  /// Group name block.
  @override
  Widget buildDynamicContent(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.item.name,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFBABABA),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget buildStaticContent(BuildContext context) => Container();
}
