import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_list_bottom_bar.dart';
import 'package:my_drugs/app/features/drug_list/widgets/switch_screen_mode_button.dart';
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
                .add(DrugListAddingStarted()),
            onDeleteButtonPressed: () => BlocProvider.of<DrugListBloc>(context)
                .add(DrugListSelectedItemsDeleted()),
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
    return Scrollbar(
      controller: _scrollController,
      child: ImplicitlyAnimatedList<DrugListItem>(
        items: state.items,
        // shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        // insertDuration: Duration(milliseconds: 350),
        // removeDuration: Duration(milliseconds: 350),
        // updateDuration: Duration(milliseconds: 350),
        insertDuration: Duration(milliseconds: 5000),
        removeDuration: Duration(milliseconds: 5000),
        updateDuration: Duration(milliseconds: 5000),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
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

/// A transition that fades the `child` in or out before shrinking or expanding
/// to the `childs` size along the `axis`.
///
/// This can be used as a item transition in an [ImplicitlyAnimatedReorderableList].
class SizeFadeTransition extends StatefulWidget {
  /// The animation to be used.
  final Animation<double> animation;

  /// The curve of the animation.
  final Curve curve;

  /// How long the [Interval] for the [SizeTransition] should be.
  ///
  /// The value must be between 0 and 1.
  ///
  /// For example a `sizeFraction` of `0.66` would result in `Interval(0.0, 0.66)`
  /// for the size animation and `Interval(0.66, 1.0)` for the opacity animation.
  final double sizeFraction;

  /// [Axis.horizontal] modifies the width,
  /// [Axis.vertical] modifies the height.
  final Axis axis;

  /// Describes how to align the child along the axis the [animation] is
  /// modifying.
  ///
  /// A value of -1.0 indicates the top when [axis] is [Axis.vertical], and the
  /// start when [axis] is [Axis.horizontal]. The start is on the left when the
  /// text direction in effect is [TextDirection.ltr] and on the right when it
  /// is [TextDirection.rtl].
  ///
  /// A value of 1.0 indicates the bottom or end, depending upon the [axis].
  ///
  /// A value of 0.0 (the default) indicates the center for either [axis] value.
  final double axisAlignment;

  /// The child widget.
  final Widget child;
  const SizeFadeTransition({
    Key key,
    @required this.animation,
    this.sizeFraction = 2 / 3,
    this.curve = Curves.linear,
    this.axis = Axis.vertical,
    this.axisAlignment = 0.0,
    this.child,
  })  : assert(animation != null),
        assert(axisAlignment != null),
        assert(axis != null),
        assert(curve != null),
        assert(sizeFraction != null),
        assert(sizeFraction >= 0.0 && sizeFraction <= 1.0),
        super(key: key);

  @override
  _SizeFadeTransitionState createState() => _SizeFadeTransitionState();
}

class _SizeFadeTransitionState extends State<SizeFadeTransition> {
  Animation size;
  Animation opacity;

  @override
  void initState() {
    super.initState();
    didUpdateWidget(widget);
  }

  @override
  void didUpdateWidget(SizeFadeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    final curve =
        CurvedAnimation(parent: widget.animation, curve: widget.curve);
    size = CurvedAnimation(
        curve: Interval(0.0, widget.sizeFraction), parent: curve);
    opacity = CurvedAnimation(
        curve: Interval(widget.sizeFraction, 1.0), parent: curve);
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: size,
      axis: widget.axis,
      axisAlignment: widget.axisAlignment,
      child: FadeTransition(
        opacity: opacity,
        child: widget.child,
      ),
    );
  }
}
