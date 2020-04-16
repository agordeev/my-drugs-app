import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_heading.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_list_bottom_bar.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_row.dart';

import 'bloc/drug_list_bloc.dart';

class DrugListScreen extends StatefulWidget {
  @override
  _DrugListScreenState createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final _animationDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
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
    return BlocBuilder<DrugListBloc, DrugListState>(
      builder: (context, state) {
        List<Widget> actions;
        Widget body;
        if (state is DrugListEmpty) {
          body = _buildEmptyStateContent(context);
        } else if (state is DrugListLoaded) {
          body = _buildLoadedStateContent(
            context,
            state,
          );
          actions = [
            FlatButton(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: state.screenMode == ScreenMode.edit
                    ? Text('Cancel')
                    : Icon(Icons.more_horiz),
              ),
              onPressed: () => BlocProvider.of<DrugListBloc>(context)
                  .add(SwitchScreenMode()),
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
          bottomNavigationBar: DrugListBottomBar(
            animationController: _animationController,
            numberOfItemsTotal: '5 items',
            numberOfItemsSelected: '0 selected',
          ),
        );
      },
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
