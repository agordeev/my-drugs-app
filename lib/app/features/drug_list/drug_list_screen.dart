import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_list_bottom_bar.dart';
import 'package:my_drugs/app/features/drug_list/widgets/switch_screen_mode_button.dart';
import 'package:my_drugs/app/misc/utils.dart';
import 'package:my_drugs/app/widgets/custom_app_bar.dart';
import 'package:my_drugs/generated/l10n.dart';

import 'bloc/drug_list_bloc.dart';
import 'models/drug_list_item.dart';

class DrugListScreen extends StatefulWidget {
  @override
  _DrugListScreenState createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _screenModeAnimationController;
  final _scrollController = ScrollController();
  final _searchTextController = TextEditingController();
  final _animationDuration = const Duration(milliseconds: 500);

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
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugListBloc, DrugListState>(
      builder: (context, state) {
        var bottomBarKey = GlobalKey<DrugListBottomBarState>();
        List<Widget> actions;
        Widget body;
        var numberOfItemsTotal = '';
        var numberOfItemsSelected = '';
        var isDeleteButtonActive = false;
        if (state is DrugListInitial) {
          if (state.isEmpty) {
            body = _buildEmptyState(context);
            numberOfItemsTotal = S.of(context).drugListTotalItems(0);
          } else {
            body = _buildInitialState(
              context,
              state,
            );

            actions = [
              SwitchScreenModeButton(
                animation: _screenModeAnimationController.view,
                onPressed: () => BlocProvider.of<DrugListBloc>(context)
                    .add(DrugListScreenModeSwitched()),
              ),
            ];
            numberOfItemsTotal = state.numberOfItemsTotal;
            numberOfItemsSelected = state.numberOfItemsSelected;
            isDeleteButtonActive = state.isDeleteButtonActive;
            bottomBarKey = state.bottomBarKey;
          }
        } else {
          body = Container();
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: S.of(context).appTitle,
            actions: actions,
            onSearchTextFieldUpdated: _onSearchTextFieldUpdated,
            platform: Theme.of(context).platform,
          ),
          body: body,
          bottomNavigationBar: DrugListBottomBar(
            key: bottomBarKey,
            screenModeAnimationController: _screenModeAnimationController,
            numberOfItemsTotal: numberOfItemsTotal,
            numberOfItemsSelected: numberOfItemsSelected,
            isDeleteButtonActive: isDeleteButtonActive,
            onAddButtonPressed: () => BlocProvider.of<DrugListBloc>(context)
                .add(const DrugListAddingStarted()),
            onDeleteButtonPressed: () => BlocProvider.of<DrugListBloc>(context)
                .add(const DrugListSelectedItemsDeleted()),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/drug_list_empty_state.png',
              width: 145.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              S.of(context).drugListNoItems,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: 240,
              child: PlatformButton(
                padding: EdgeInsets.zero,
                android: (context) => MaterialRaisedButtonData(
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
                ios: (context) => CupertinoButtonData(
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => BlocProvider.of<DrugListBloc>(context)
                    .add(const DrugListAddingStarted()),
                child: Text(
                  S.of(context).manageDrugAddDrugModeActionButtonTitle,
                ),
              ),
            )
          ],
        ),
      );

  Widget _buildInitialState(
    BuildContext context,
    DrugListInitial state,
  ) {
    return Scrollbar(
      controller: _scrollController,
      child: ImplicitlyAnimatedList<DrugListItem>(
        items: state.items,
        spawnIsolate: false,
        insertDuration: const Duration(milliseconds: 350),
        removeDuration: const Duration(milliseconds: 350),
        updateDuration: const Duration(milliseconds: 350),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet() ? 24.0 : 8.0,
          vertical: 12.0,
        ),
        areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
        itemBuilder: (context, itemAnimation, item, index) {
          return SizeFadeTransition(
            sizeFraction: 0.7,
            curve: Curves.easeInOut,
            animation: itemAnimation,
            child: item.build(
              context,
              _screenModeAnimationController,
            ),
          );
        },
        updateItemBuilder: (context, itemAnimation, item) {
          return FadeTransition(
            opacity: itemAnimation,
            child: item.build(
              context,
              _screenModeAnimationController,
            ),
          );
        },
      ),
    );
  }

  void _onSearchTextFieldUpdated(String text) =>
      BlocProvider.of<DrugListBloc>(context).add(
        DrugListSearchTextFieldUpdated(
          text,
        ),
      );
}
