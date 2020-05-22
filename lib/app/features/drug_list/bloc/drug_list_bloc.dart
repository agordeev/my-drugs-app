import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_item_group.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_heading_row_widget.dart';
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

  List<DrugItemGroup> _groups;
  int get _selectedItemsCount => _groups.fold(
        0,
        (previousValue, group) =>
            previousValue +
            group.items.fold(
              0,
              (previousValue, item) =>
                  previousValue + (item.isSelected ? 1 : 0),
            ),
      );

  /// Avoid to setting this property directly.
  /// Use [setScreenMode()] instead to update the bottom bar state.
  ScreenMode _screenMode = ScreenMode.normal;

  void _setScreenMode(ScreenMode screenMode) {
    _screenMode = screenMode;
    _screenModeStreamController.add(_screenMode);
  }

  final _screenModeStreamController = StreamController<ScreenMode>.broadcast();
  Stream<ScreenMode> get screenMode => _screenModeStreamController.stream;

  final GlobalKey<DrugListBottomBarState> _bottomBarKey = GlobalKey();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final Duration _animationDuration = Duration(milliseconds: 300);

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
    _groups ??= _buildGroups(_filteredDrugs);
    final selectedItemsCount = _selectedItemsCount;
    if (_filteredDrugs.isEmpty) {
      _setScreenMode(ScreenMode.normal);
    }
    var numberOfItemsTotal = _localizations.drugListTotalItems(_drugs.length);
    if (_filteredDrugs.length != _drugs.length) {
      numberOfItemsTotal = '${_filteredDrugs.length}/$numberOfItemsTotal';
    }
    return DrugListInitial(
      _drugs.isEmpty,
      _screenMode,
      _bottomBarKey,
      _listKey,
      _groups,
      numberOfItemsTotal,
      _localizations.drugListTotalItemsSelected(selectedItemsCount),
      selectedItemsCount > 0,
    );
  }

  List<DrugItemGroup> _buildGroups(List<Drug> drugs) {
    final expired = drugs.where(_isDrugExpired).toList();
    final notExpired = drugs.where((e) => !_isDrugExpired(e)).toList();
    var result = <DrugItemGroup>[];
    if (expired.isNotEmpty) {
      final groupKey = GlobalKey<DrugHeadingRowState>();
      result.add(
        DrugItemGroup(
          groupKey,
          GlobalKey(),
          _localizations.drugListExpiredGroupTitle.toUpperCase(),
          expired
              .map(
                (e) => DrugItem(
                  GlobalKey(),
                  e,
                  expiresOnDateFormat.format(e.expiresOn),
                  true,
                ),
              )
              .toList(),
          true,
        ),
      );
    }
    if (notExpired.isNotEmpty) {
      final groupKey = GlobalKey<DrugHeadingRowState>();
      result.add(
        DrugItemGroup(
          groupKey,
          GlobalKey(),
          _localizations.drugListNotExpiredGroupTitle.toUpperCase(),
          notExpired
              .map(
                (e) => DrugItem(
                  GlobalKey(),
                  e,
                  expiresOnDateFormat.format(e.expiresOn),
                  false,
                ),
              )
              .toList(),
          false,
        ),
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
    } else if (event is SelectDeselectDrug) {
      yield* _mapSelectDeselectDrugEventToState(event);
    } else if (event is DrugListGroupSelectionChanged) {
      yield* _mapSelectDeselectGroupEventToState(event);
    } else if (event is DrugListGroupItemDeleted) {
      yield* _mapGroupItemDeletedEventToState(event);
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
    _groups.forEach((group) => group.deselect());
    yield _buildState();
  }

  Stream<DrugListState> _mapSelectDeselectDrugEventToState(
    SelectDeselectDrug event,
  ) async* {
    final group = event.group;
    event.item.toggleSelection(!event.item.isSelected);
    // If all drugs from the current group are selected, then mark it as selected too.
    group.toggleSelection(group.areAllItemsSelected);
    _updateBottomBarDeleteButtonColor();
    yield _buildState();
  }

  Stream<DrugListState> _mapSelectDeselectGroupEventToState(
    DrugListGroupSelectionChanged event,
  ) async* {
    event.group.toggleSelection(!event.group.isSelected);
    event.group.updateItemsSelection();
    _updateBottomBarDeleteButtonColor();
    yield _buildState();
  }

  Stream<DrugListState> _mapGroupItemDeletedEventToState(
    DrugListGroupItemDeleted event,
  ) async* {
    try {
      await _repository.delete([event.item.drug.id]);
      _filteredDrugs.removeWhere((element) => element.id == event.item.drug.id);

      final group = event.group;
      if (group.items.length == 1) {
        // The group will become empty after item removal. Delete the entire group.
        final groupIndex = _groups.indexOf(group);
        if (groupIndex > -1) {
          _groups.removeAt(groupIndex);
          _listKey.currentState.removeItem(
            groupIndex,
            event.groupBuilder,
            duration: _animationDuration,
          );
          if (_groups.isEmpty) {
            await Future.delayed(Duration(milliseconds: 300));
            yield _buildState();
          }
        }
      } else {
        group.removeItem(event.item, event.itemBuilder);
      }
      _sendScreenAnalytics();
      yield _buildState();
    } catch (e) {
      print(e);
    }
  }

  Stream<DrugListState> _mapSelectedItemsDeletedEventToState(
    DrugListSelectedItemsDeleted event,
  ) async* {
    var selectedGroupsCount = _groups.where((group) => group.isSelected).length;
    while (selectedGroupsCount > 0) {
      final index = _groups.indexWhere((group) => group.isSelected);
      await _repository
          .delete(_groups[index].items.map((e) => e.drug.id).toList());
      final group = _groups.removeAt(index);
      group.items.forEach(
          (item) => _filteredDrugs.removeWhere((e) => e.id == item.drug.id));
      _listKey.currentState.removeItem(
        index,
        (context, animation) => event.groupBuilder(context, group, animation),
        duration: _animationDuration,
      );
      selectedGroupsCount -= 1;
    }

    if (_groups.isEmpty) {
      await Future.delayed(_animationDuration);
      yield _buildState();
    } else {
      for (var group in _groups) {
        final selectedItemsIds = group.selectedItemsIds;
        await _repository.delete(selectedItemsIds);
        _filteredDrugs.removeWhere((e) => selectedItemsIds.contains(e.id));
        group.removeSelectedItems((context, item, animation) =>
            event.itemBuilder(context, group, item, animation));
      }
    }
    _setScreenMode(ScreenMode.normal);
    _updateBottomBarDeleteButtonColor();
    _sendScreenAnalytics();
    yield _buildState();
  }

  Stream<DrugListState> _mapAddingStartedEventToState(
    DrugListAddingStarted event,
  ) async* {
    final drug =
        await _navigatorKey.currentState.pushNamed<Drug>(AppRoutes.manageDrug);
    if (drug != null) {
      _filteredDrugs.add(drug);
      _filteredDrugs.sort();
      final oldGroupsLength = _groups.length;
      _groups = _buildGroups(_filteredDrugs);
      if (_groups.length > oldGroupsLength) {
        // A new group was added.
        final indexToAdd = _isDrugExpired(drug) ? 0 : 1;
        _listKey.currentState?.insertItem(indexToAdd);
      }
      _sendScreenAnalytics();
      yield _buildState();
    }
  }

  Stream<DrugListState> _mapEditingStartedEventToState(
    DrugListEditingStarted event,
  ) async* {
    final index = _filteredDrugs.indexWhere((drug) => drug.id == event.id);
    if (index == -1) {
      print('Unable edit a drug ${event.id}: unable to find its index');
      return;
    }
    final selectedDrug = _filteredDrugs[index];
    final drug = await _navigatorKey.currentState
        .pushNamed<Drug>(AppRoutes.manageDrug, arguments: selectedDrug);
    if (drug != null) {
      _filteredDrugs[index] = drug;
      // Sort in case if [expiresOn] was updated.
      // Sorting uses the default [Comparator]. See [Drug.compareTo] for more info.
      _filteredDrugs.sort();
      _groups = _buildGroups(_filteredDrugs);
      _sendScreenAnalytics();
      yield _buildState();
    }
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
    if (_filteredDrugs.isEmpty) {
      for (var group in _groups) {
        final expectedDrugsForGroup = _filteredDrugs.where((e) {
          if (group.isExpired) {
            return _isDrugExpired(e);
          } else {
            return !_isDrugExpired(e);
          }
        }).toList();
        group.filterItems(
          expectedDrugsForGroup,
          event.itemBuilder,
        );
      }
    } else {}
    // Wait until the animated lists are visible back, then start adding/removing items.
    // Otherwise app state would be null.
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      for (var group in _groups) {
        final expectedDrugsForGroup = _filteredDrugs.where((e) {
          if (group.isExpired) {
            return _isDrugExpired(e);
          } else {
            return !_isDrugExpired(e);
          }
        }).toList();
        group.filterItems(
          expectedDrugsForGroup,
          event.itemBuilder,
        );
      }
    });
  }

  bool _isDrugExpired(Drug drug) {
    return drug.expiresOn.compareTo(_firstDayOfCurrentMonth) < 0;
  }

  void _updateBottomBarDeleteButtonColor() {
    if (_selectedItemsCount > 0) {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.forward();
    } else {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.reverse();
    }
  }

  void _sendScreenAnalytics() {
    _analytics.setUserProperty(
      name: 'drugs_count_total',
      value: '${_drugs.length}',
    );
    var expiredDrugsCount = 0;
    var notExpiredDrugsCount = 0;
    _groups.forEach((group) {
      if (group.isExpired) {
        expiredDrugsCount = group.items.length;
      } else {
        notExpiredDrugsCount = group.items.length;
      }
    });
    _analytics.setUserProperty(
      name: 'drugs_count_expired',
      value: '$expiredDrugsCount',
    );
    _analytics.setUserProperty(
      name: 'drugs_count_not_expired',
      value: '$notExpiredDrugsCount',
    );
  }
}
