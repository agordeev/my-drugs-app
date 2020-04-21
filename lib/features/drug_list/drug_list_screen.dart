import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_list_bottom_bar.dart';

import 'bloc/drug_list_bloc.dart';

class DrugListScreen extends StatefulWidget {
  @override
  _DrugListScreenState createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _screenModeAnimationController;
  final _animationDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    _screenModeAnimationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    BlocProvider.of<DrugListBloc>(context).screenMode.listen((screenMode) {
      if (screenMode == ScreenMode.edit) {
        _screenModeAnimationController.forward();
      } else {
        _screenModeAnimationController.reverse();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _screenModeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugListBloc, DrugListState>(
      builder: (context, state) {
        GlobalKey<DrugListBottomBarState> bottomBarKey = GlobalKey();
        List<Widget> actions;
        Widget body;
        String numberOfItemsTotal = '';
        String numberOfItemsSelected = '';
        bool isDeleteButtonActive = false;
        if (state is DrugListEmpty) {
          body = _buildEmptyStateContent(context);
          numberOfItemsTotal = 'No items';
        } else if (state is DrugListLoaded) {
          body = _buildLoadedStateContent(
            context,
            state,
          );
          actions = [
            PlatformButton(
              androidFlat: (context) => MaterialFlatButtonData(),
              child: AnimatedIcon(
                icon: AnimatedIcons.arrow_menu,
                progress: _screenModeAnimationController,
              ),
              onPressed: () => BlocProvider.of<DrugListBloc>(context)
                  .add(SwitchScreenMode()),
            ),
          ];
          numberOfItemsTotal = state.numberOfItemsTotal;
          numberOfItemsSelected = state.numberOfItemsSelected;
          isDeleteButtonActive = state.isDeleteButtonActive;
          bottomBarKey = state.bottomBarKey;
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
            key: bottomBarKey,
            screenModeAnimationController: _screenModeAnimationController,
            numberOfItemsTotal: numberOfItemsTotal,
            numberOfItemsSelected: numberOfItemsSelected,
            isDeleteButtonActive: isDeleteButtonActive,
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
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(8, 12, 16, 12),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return item.build(
          context,
          state.screenMode == ScreenMode.edit,
          _screenModeAnimationController,
        );
      },
    );
  }
}
