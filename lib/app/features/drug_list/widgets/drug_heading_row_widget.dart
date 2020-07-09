import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/app/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_heading_item.dart';
import 'package:my_drugs/app/misc/utils.dart';

import 'drug_list_row.dart';

class DrugHeadingRowWidget extends DrugListRow {
  final DrugListHeadingItem group;

  DrugHeadingRowWidget({
    Key key,
    @required this.group,
    @required bool isSelected,
    @required Animation<double> editModeAnimation,
  }) : super(
          key: key,
          isSelected: isSelected,
          editModeAnimation: editModeAnimation,
        );

  @override
  State<StatefulWidget> createState() => DrugHeadingRowState();
}

class DrugHeadingRowState extends DrugListRowState<DrugHeadingRowWidget> {
  @override
  Widget buildScaffold(BuildContext context, Widget animatedChild) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet() ? 16.0 : 8.0),
      child: animatedChild,
    );
  }

  /// Group name block.
  @override
  Widget buildDynamicContent(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.group.name,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFFBABABA),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget buildStaticContent(BuildContext context) => Container();

  @override
  void onTap() {
    final bloc = BlocProvider.of<DrugListBloc>(context);
    final screenMode = bloc.currentScreenMode;
    if (screenMode == ScreenMode.edit) {
      bloc.add(DrugListGroupSelectionToggled(
        widget.group,
      ));
    } else {}
  }
}
