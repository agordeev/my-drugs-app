import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_item.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_list_bottom_bar.dart';
import 'package:my_drugs/app/routes/app_routes.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/generated/l10n.dart';
import 'package:my_drugs/models/drug.dart';

part 'drug_list_event.dart';
part 'drug_list_state.dart';

enum ScreenMode { normal, edit }

DateFormat expiresOnDateFormat = DateFormat('MMMM yyyy');

class DrugListBloc extends Bloc<DrugListEvent, DrugListState> {
  final S _localizations;
  final GlobalKey<NavigatorState> _navigatorKey;
  final AbstractDrugRepository _repository;
  final FirebaseAnalytics _analytics;

  /// The original array of drugs.
  final List<Drug> _drugs;

  /// The array of drugs that is currently visible.
  List<Drug> _filteredDrugs;

  List<DrugListItem> _items;

  /// Avoid to setting this property directly.
  /// Use [setScreenMode()] instead to update the bottom bar state.
  ScreenMode _screenMode = ScreenMode.normal;
  ScreenMode get currentScreenMode => _screenMode;

  void _setScreenMode(ScreenMode screenMode) {
    _screenMode = screenMode;
    _screenModeStreamController.add(_screenMode);
  }

  final _screenModeStreamController = StreamController<ScreenMode>.broadcast();
  Stream<ScreenMode> get screenMode => _screenModeStreamController.stream;

  final GlobalKey<DrugListBottomBarState> _bottomBarKey = GlobalKey();

  static final _firstDayOfCurrentMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);

  DrugListBloc(
    this._localizations,
    this._navigatorKey,
    this._repository,
    this._analytics,
    this._drugs,
  ) : _filteredDrugs = _drugs {
    _sendScreenAnalytics();
  }

  @override
  Future<void> close() {
    _screenModeStreamController.close();
    return super.close();
  }

  @override
  DrugListState get initialState => _buildState();

  DrugListState _buildState() {
    _filteredDrugs.sort();
    _items ??= _buildItems(_filteredDrugs);
    final selectedItemsCount = _calculateSelectedItemsCount();
    if (_filteredDrugs.isEmpty) {
      _setScreenMode(ScreenMode.normal);
    }
    var numberOfItemsTotal =
        _localizations.drugListTotalItems(_filteredDrugs.length);
    if (_filteredDrugs.length != _drugs.length) {
      numberOfItemsTotal = '${_filteredDrugs.length}/$numberOfItemsTotal';
    }
    return DrugListInitial(
      _drugs.isEmpty,
      _screenMode,
      _bottomBarKey,
      _items,
      numberOfItemsTotal,
      _localizations.drugListTotalItemsSelected(selectedItemsCount),
      selectedItemsCount > 0,
    );
  }

  List<DrugListItem> _buildItems(List<Drug> drugs) {
    final expired = drugs.where(_isDrugExpired).toList();
    final notExpired = drugs.where((e) => !_isDrugExpired(e)).toList();
    var result = <DrugListItem>[];
    if (expired.isNotEmpty) {
      result.add(
        DrugListHeadingItem(
          _localizations.drugListExpiredGroupTitle.toUpperCase(),
          false,
        ),
      );
      result.addAll(
        expired
            .map(
              (e) => DrugListRowItem(
                e.id,
                e.name,
                expiresOnDateFormat.format(e.expiresOn),
                true,
                false,
              ),
            )
            .toList(),
      );
    }
    if (notExpired.isNotEmpty) {
      result.add(
        DrugListHeadingItem(
          _localizations.drugListNotExpiredGroupTitle.toUpperCase(),
          false,
        ),
      );
      result.addAll(
        notExpired
            .map(
              (e) => DrugListRowItem(
                e.id,
                e.name,
                expiresOnDateFormat.format(e.expiresOn),
                false,
                false,
              ),
            )
            .toList(),
      );
    }
    return result;
  }

  @override
  Stream<DrugListState> mapEventToState(
    DrugListEvent event,
  ) async* {
    if (event is DrugListScreenModeSwitched) {
      yield* _mapSwitchScreenModeEventToState();
    } else if (event is DrugListItemSelectionToggled) {
      yield* _mapItemSelectionToggledEventToState(event);
    } else if (event is DrugListGroupSelectionToggled) {
      yield* _mapGroupSelectionToggledEventToState(event);
    } else if (event is DrugListItemDeleted) {
      yield* _mapItemDeletedEventToState(event);
    } else if (event is DrugListSelectedItemsDeleted) {
      yield* _mapSelectedItemsDeletedEventToState(event);
    } else if (event is DrugListAddingStarted) {
      yield* _mapAddingStartedEventToState(event);
    } else if (event is DrugListEditingStarted) {
      yield* _mapEditingStartedEventToState(event);
    } else if (event is DrugListSearchTextFieldUpdated) {
      yield* _mapSearchTextFieldUpdatedEventToState(event);
    }
  }

  Stream<DrugListState> _mapSwitchScreenModeEventToState() async* {
    if (_screenMode == ScreenMode.edit) {
      _setScreenMode(ScreenMode.normal);
    } else {
      _setScreenMode(ScreenMode.edit);
    }
    // _groups.forEach((group) => group.deselect());
    yield _buildState();
  }

  Stream<DrugListState> _mapItemSelectionToggledEventToState(
    DrugListItemSelectionToggled event,
  ) async* {
    final item = event.item;
    item.toggleSelection(!item.isSelected);
    _updateBottomBarDeleteButtonColor();
    yield _buildState();
    // TODO: If all drugs from the current group are selected, then mark it as selected too.
    // group.toggleSelection(group.areAllItemsSelected);
  }

  Stream<DrugListState> _mapGroupSelectionToggledEventToState(
    DrugListGroupSelectionToggled event,
  ) async* {
    final group = event.group;
    group.toggleSelection(!group.isSelected);
    // TODO: Update drugs selection
    // event.group.updateItemsSelection();
    _updateBottomBarDeleteButtonColor();
    yield _buildState();
  }

  Stream<DrugListState> _mapItemDeletedEventToState(
    DrugListItemDeleted event,
  ) async* {
    try {
      print(_filteredDrugs.length);
      await _repository.delete([event.id]);
      _filteredDrugs.removeWhere((element) => element.id == event.id);
      _sendScreenAnalytics();
      print(_filteredDrugs.length);
      yield _buildState();
    } catch (e) {
      print(e);
    }
  }

  Stream<DrugListState> _mapSelectedItemsDeletedEventToState(
    DrugListSelectedItemsDeleted event,
  ) async* {
    // var selectedGroupsCount = _groups.where((group) => group.isSelected).length;
    // while (selectedGroupsCount > 0) {
    //   final index = _groups.indexWhere((group) => group.isSelected);
    //   await _repository
    //       .delete(_groups[index].items.map((e) => e.drug.id).toList());
    //   final group = _groups.removeAt(index);
    //   group.items.forEach(
    //       (item) => _filteredDrugs.removeWhere((e) => e.id == item.drug.id));
    //   _listKey.currentState.removeItem(
    //     index,
    //     (context, animation) => event.groupBuilder(context, group, animation),
    //     duration: _animationDuration,
    //   );
    //   selectedGroupsCount -= 1;
    // }

    // if (_groups.isEmpty) {
    //   await Future.delayed(_animationDuration);
    //   yield _buildState();
    // } else {
    //   for (var group in _groups) {
    //     final selectedItemsIds = group.selectedItemsIds;
    //     await _repository.delete(selectedItemsIds);
    //     _filteredDrugs.removeWhere((e) => selectedItemsIds.contains(e.id));
    //     group.removeSelectedItems((context, item, animation) =>
    //         event.itemBuilder(context, group, item, animation));
    //   }
    // }
    // _setScreenMode(ScreenMode.normal);
    // _updateBottomBarDeleteButtonColor();
    // _sendScreenAnalytics();
    // yield _buildState();
  }

  Stream<DrugListState> _mapAddingStartedEventToState(
    DrugListAddingStarted event,
  ) async* {
    final drug =
        await _navigatorKey.currentState.pushNamed<Drug>(AppRoutes.manageDrug);
    // TODO: Remove
    // final drug = Drug(
    //   id: 'new',
    //   expiresOn: DateTime.now(),
    //   name: 'New',
    //   createdAt: DateTime.now(),
    // );
    if (drug != null) {
      _filteredDrugs.add(drug);
      _filteredDrugs.sort();
      _sendScreenAnalytics();
      yield _buildState();
    }
  }

  Stream<DrugListState> _mapEditingStartedEventToState(
    DrugListEditingStarted event,
  ) async* {
    // final index = _filteredDrugs.indexWhere((drug) => drug.id == event.id);
    // if (index == -1) {
    //   print('Unable edit a drug ${event.id}: unable to find its index');
    //   return;
    // }
    // final selectedDrug = _filteredDrugs[index];
    // final drug = await _navigatorKey.currentState
    //     .pushNamed<Drug>(AppRoutes.manageDrug, arguments: selectedDrug);
    // if (drug != null) {
    //   _filteredDrugs[index] = drug;
    //   // Sort in case if [expiresOn] was updated.
    //   // Sorting uses the default [Comparator]. See [Drug.compareTo] for more info.
    //   _filteredDrugs.sort();
    //   _groups = _buildItems(_filteredDrugs);
    //   _sendScreenAnalytics();
    //   yield _buildState();
    // }
  }

  Stream<DrugListState> _mapSearchTextFieldUpdatedEventToState(
    DrugListSearchTextFieldUpdated event,
  ) async* {
    if (event.text.isEmpty) {
      _filteredDrugs = _drugs;
    } else {
      _filteredDrugs = _drugs
          .where(
            (e) => e.lowercasedName.contains(
              event.text.toLowerCase(),
            ),
          )
          .toList();
    }

    yield _buildState();
  }

  int _calculateSelectedItemsCount() =>
      _items.where((e) => e.isSelected).length;

  bool _isDrugExpired(Drug drug) {
    return drug.expiresOn.compareTo(_firstDayOfCurrentMonth) < 0;
  }

  void _updateBottomBarDeleteButtonColor() {
    if (_calculateSelectedItemsCount() > 0) {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.forward();
    } else {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.reverse();
    }
  }

  void _sendScreenAnalytics() {
    // _analytics.setUserProperty(
    //   name: 'drugs_count_total',
    //   value: '${_drugs.length}',
    // );
    // var expiredDrugsCount = 0;
    // var notExpiredDrugsCount = 0;
    // _groups.forEach((group) {
    //   if (group.isExpired) {
    //     expiredDrugsCount = group.items.length;
    //   } else {
    //     notExpiredDrugsCount = group.items.length;
    //   }
    // });
    // _analytics.setUserProperty(
    //   name: 'drugs_count_expired',
    //   value: '$expiredDrugsCount',
    // );
    // _analytics.setUserProperty(
    //   name: 'drugs_count_not_expired',
    //   value: '$notExpiredDrugsCount',
    // );
  }
}
