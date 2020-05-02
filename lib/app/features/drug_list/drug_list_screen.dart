import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:my_drugs/app/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_group_item_widget.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_group_widget.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_list_bottom_bar.dart';
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
        var bottomBarKey = GlobalKey<DrugListBottomBarState>();
        List<Widget> actions;
        Widget body;
        var numberOfItemsTotal = '';
        var numberOfItemsSelected = '';
        var isDeleteButtonActive = false;
        if (state is DrugListInitial) {
          if (state.isEmpty) {
            body = _buildEmptyStateContent(context);
            numberOfItemsTotal = 'No items';
          } else {
            body = _buildInitialStateContent(
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
          appBar: AppBar(
            title: Text(FlutterI18n.translate(context, 'app.title')),
            actions: actions,
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

  Widget _buildEmptyStateContent(BuildContext context) => Center(
        child: Text('No drugs added yet'),
      );

  Widget _buildInitialStateContent(
    BuildContext context,
    DrugListInitial state,
  ) {
    final isInEditMode = state.screenMode == ScreenMode.edit;
    return Container(
      height: double.infinity,
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: AnimatedList(
            key: state.listKey,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            shrinkWrap: true,
            initialItemCount: state.groups.length,
            itemBuilder: (context, groupIndex, groupAnimation) =>
                DrugGroupWidget(
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
        ),
      ),
    );
  }

  void _presentBottomSheet(
    BuildContext context,
    DrugGroup group,
    DrugGroupItem item,
    bool isInEditMode,
  ) {
    final deleteButtonHandler = () => _onContextMenuDeletePressed(
          context,
          group,
          item,
          isInEditMode,
        );
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<DrugListBloc>(context)
                    .add(DrugListEditingStarted(item.id));
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Delete'),
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
              'Edit',
              () {},
            ),
            _buildBottomSheetRow(
              context,
              Icons.delete,
              'Delete',
              deleteButtonHandler,
            ),
          ],
        ),
      );
    }
  }

  void _onContextMenuDeletePressed(
    BuildContext context,
    DrugGroup group,
    DrugGroupItem item,
    bool isInEditMode,
  ) {
    Navigator.of(context).pop();
    BlocProvider.of<DrugListBloc>(context).add(
      DrugListGroupItemDeleted(
        item,
        (context, animation) => DrugGroupWidget(
          group: group,
          isInEditMode: isInEditMode,
          editModeAnimation: _screenModeAnimationController,
          listAnimation: animation,
          onPresentContextMenuTap: null,
        ),
        (context, animation) => DrugGroupItemWidget(
          item: item,
          isInEditMode: isInEditMode,
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
        (context, group, animation) => DrugGroupWidget(
          group: group,
          isInEditMode: isInEditMode,
          editModeAnimation: _screenModeAnimationController,
          listAnimation: animation,
          onPresentContextMenuTap: null,
        ),
        (context, item, animation) => DrugGroupItemWidget(
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
