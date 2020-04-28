import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/app/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/app/features/drug_list/drug_list_item.dart';

import 'drug_list_row.dart';

class DrugHeadingRowWidget extends DrugListRow {
  final DrugGroup item;
  final bool isInEditMode;

  DrugHeadingRowWidget({
    @required this.item,
    @required this.isInEditMode,
    @required Animation<double> editModeAnimation,
  }) : super(
          key: item.key,
          editModeAnimation: editModeAnimation,
        );

  @override
  State<StatefulWidget> createState() => DrugHeadingRowState();
}

class DrugHeadingRowState extends DrugListRowState<DrugHeadingRowWidget> {
  @override
  Widget buildScaffold(BuildContext context, Widget animatedChild) {
    return GestureDetector(
      onTap: widget.isInEditMode
          ? () => BlocProvider.of<DrugListBloc>(context).add(
                DrugListGroupSelectionChanged(
                  widget.item,
                ),
              )
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
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
