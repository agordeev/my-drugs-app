import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item_group.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_group_widget.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_item_widget.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_list_bottom_bar.dart';
import 'package:my_drugs/app/widgets/custom_cupertino_search_bar.dart';
import 'package:my_drugs/generated/l10n.dart';
import 'package:my_drugs/shared/painters/screen_mode_button_painter.dart';

import 'bloc/drug_list_bloc.dart';

class DrugListScreen extends StatefulWidget {
  @override
  _DrugListScreenState createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _screenModeAnimationController;
  final _scrollController = ScrollController();
  final _searchTextController = TextEditingController();
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
              PlatformButton(
                androidFlat: (context) => MaterialFlatButtonData(),
                child: CustomPaint(
                  size: Size(24, 24),
                  painter: ScreenModeButtonPainter(
                      Theme.of(context).colorScheme.primary,
                      _screenModeAnimationController),
                ),
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
          appBar: AppBar(
            title: Text(S.of(context).appTitle),
            actions: actions,
            bottom: CustomCupertinoSearchBar(
              controller: _searchTextController,
              onChanged: _onSearchTextFieldUpdated,
            ),
          ),
          body: body,
          bottomNavigationBar: DrugListBottomBar(
            key: bottomBarKey,
            screenModeAnimationController: _screenModeAnimationController,
            numberOfItemsTotal: numberOfItemsTotal,
            numberOfItemsSelected: numberOfItemsSelected,
            isDeleteButtonActive: isDeleteButtonActive,
            onAddButtonPressed: () => BlocProvider.of<DrugListBloc>(context)
                .add(DrugListAddingStarted()),
            onDeleteButtonPressed: () => _deleteSelectedItems(context, state),
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
            SizedBox(height: 16.0),
            Text(
              S.of(context).drugListNoItems,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),
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
                child: Text(
                  S.of(context).manageDrugAddDrugModeActionButtonTitle,
                ),
                onPressed: () => BlocProvider.of<DrugListBloc>(context)
                    .add(DrugListAddingStarted()),
              ),
            )
          ],
        ),
      );

  Widget _buildInitialState(
    BuildContext context,
    DrugListInitial state,
  ) {
    final isInEditMode = state.screenMode == ScreenMode.edit;
    return Scrollbar(
      controller: _scrollController,
      child: AnimatedList(
        controller: _scrollController,
        key: state.listKey,
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        initialItemCount: state.groups.length,
        itemBuilder: (context, groupIndex, groupAnimation) =>
            DrugItemGroupWidget(
          group: state.groups[groupIndex],
          isInEditMode: isInEditMode,
          editModeAnimation: _screenModeAnimationController,
          listAnimation: groupAnimation,
          onPresentContextMenuTap: (item) => _presentBottomSheet(
            context,
            state.groups[groupIndex],
            item,
            isInEditMode,
          ),
        ),
      ),
    );
  }

  void _presentBottomSheet(
    BuildContext context,
    DrugItemGroup group,
    DrugItem item,
    bool isInEditMode,
  ) {
    final deleteButtonHandler = () => _onContextMenuDeletePressed(
          context,
          group,
          item,
          isInEditMode,
        );
    final editButtonHandler = () {
      Navigator.of(context).pop();
      BlocProvider.of<DrugListBloc>(context)
          .add(DrugListEditingStarted(item.drug.id));
    };
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                S.of(context).buttonEdit,
              ),
              onPressed: editButtonHandler,
            ),
            CupertinoActionSheetAction(
              child: Text(
                S.of(context).buttonDelete,
              ),
              isDestructiveAction: true,
              onPressed: deleteButtonHandler,
            ),
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (_) => Wrap(
          children: <Widget>[
            SizedBox(height: 8),
            _buildBottomSheetRow(
              context,
              Icons.edit,
              S.of(context).buttonEdit,
              editButtonHandler,
            ),
            _buildBottomSheetRow(
              context,
              Icons.delete,
              S.of(context).buttonDelete,
              deleteButtonHandler,
            ),
          ],
        ),
      );
    }
  }

  void _onContextMenuDeletePressed(
    BuildContext context,
    DrugItemGroup group,
    DrugItem item,
    bool isInEditMode,
  ) {
    Navigator.of(context).pop();
    BlocProvider.of<DrugListBloc>(context).add(
      DrugListGroupItemDeleted(
        group,
        item,
        (context, animation) => DrugItemGroupWidget(
          group: group,
          isInEditMode: isInEditMode,
          editModeAnimation: _screenModeAnimationController,
          listAnimation: animation,
          onPresentContextMenuTap: null,
        ),
        (context, animation) => DrugItemWidget(
          group: group,
          item: item,
          isInEditMode: isInEditMode,
          editModeAnimation: _screenModeAnimationController,
          animation: animation,
          onPresentContextMenuTap: null,
        ),
      ),
    );
  }

  void _onSearchTextFieldUpdated(String text) {
    BlocProvider.of<DrugListBloc>(context).add(
      DrugListSearchTextFieldUpdated(
        text,
        (context, group, item, animation) => DrugItemWidget(
          group: group,
          item: item,
          isInEditMode: false,
          editModeAnimation: _screenModeAnimationController,
          animation: animation,
          onPresentContextMenuTap: null,
        ),
      ),
    );
  }

  Widget _buildBottomSheetRow(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  icon,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: 8),
              Text(text),
            ],
          ),
        ),
      );

  void _deleteSelectedItems(BuildContext context, DrugListState state) {
    if (state is DrugListInitial) {
      final isInEditMode = state.screenMode == ScreenMode.edit;
      BlocProvider.of<DrugListBloc>(context).add(DrugListSelectedItemsDeleted(
        (context, group, animation) => DrugItemGroupWidget(
          group: group,
          isInEditMode: isInEditMode,
          editModeAnimation: _screenModeAnimationController,
          listAnimation: animation,
          onPresentContextMenuTap: null,
        ),
        (context, group, item, animation) => DrugItemWidget(
          group: group,
          item: item,
          isInEditMode: isInEditMode,
          editModeAnimation: _screenModeAnimationController,
          animation: animation,
          onPresentContextMenuTap: null,
        ),
      ));
    }
  }
}
