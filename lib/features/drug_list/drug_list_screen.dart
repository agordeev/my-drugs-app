import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/features/drug_list/drug_heading.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/features/drug_list/drug_row.dart';

import 'bloc/drug_list_bloc.dart';

class DrugListScreen extends StatefulWidget {
  @override
  _DrugListScreenState createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    BlocProvider.of<DrugListBloc>(context).screenMode.listen((screenMode) {
      if (screenMode == ScreenMode.edit) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugListBloc, DrugListState>(builder: (context, state) {
      List<Widget> actions;
      Widget body;
      if (state is DrugListEmpty) {
        body = _buildEmptyStateContent(context);
      } else if (state is DrugListLoaded) {
        body = _buildLoadedStateContent(
          context,
          state,
        );
        final onPressed = () =>
            BlocProvider.of<DrugListBloc>(context).add(SwitchScreenMode());
        actions = [
          state.screenMode == ScreenMode.edit
              ? FlatButton(
                  child: Text('Cancel'),
                  onPressed: onPressed,
                )
              : IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: onPressed,
                ),
        ];
      } else {
        body = Container();
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('My Drugs'),
          actions: actions,
        ),
        body: body,
        bottomNavigationBar: _buildBottomNavigationBar(context),
      );
    });
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Colors.grey[350],
            ),
          )),
      child: SafeArea(
        child: Container(
          height: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyStateContent(BuildContext context) => Center(
        child: Text('No drugs added yet'),
      );

  Widget _buildLoadedStateContent(
    BuildContext context,
    DrugListLoaded state,
  ) {
    final horizontalPadding = 16.0;
    final drugRowWidth =
        MediaQuery.of(context).size.width - horizontalPadding * 2;
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        if (item is DrugHeadingItem) {
          return DrugHeading(
            item: item,
            animationController: _animationController,
          );
        } else if (item is DrugItem) {
          return DrugRow(
            item: item,
            animationController: _animationController,
            width: drugRowWidth,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
