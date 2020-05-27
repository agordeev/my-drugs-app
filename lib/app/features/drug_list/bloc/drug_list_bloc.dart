import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_heading_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_item.dart';
import 'package:my_drugs/app/features/drug_list/models/drug_list_row_item.dart';
import 'package:my_drugs/app/features/drug_list/widgets/drug_list_bottom_bar.dart';
import 'package:my_drugs/app/misc/analytics_sender.dart';
import 'package:my_drugs/app/routes/app_routes.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/generated/l10n.dart';
import 'package:my_drugs/models/drug.dart';

part 'drug_list_event.dart';
part 'drug_list_state.dart';

enum ScreenMode { normal, edit }

DateFormat expiresOnDateFormat = DateFormat('MMMM yyyy');

class DrugListBloc extends Bloc<DrugListEvent, DrugListState>
    with AnalyticsSender {
  final S _localizations;
  final GlobalKey<NavigatorState> _navigatorKey;
  final AbstractDrugRepository _repository;

  /// The original array of drugs.
  final List<Drug> _drugs;

  /// The array of drugs that is currently visible.
  List<Drug> _filteredDrugs;

  List<DrugListItem> _items;

  /// Avoid to setting this property directly.
  /// Use [setScreenMode()] instead to update the bottom bar state.
  ScreenMode _screenMode = ScreenMode.normal;
  ScreenMode get currentScreenMode => _screenMode;

  @override
  final FirebaseAnalytics analytics;

  /// Used for analytics.
  @override
  int get drugsCountTotal => _drugs.length;

  /// Used for analytics.
  @override
  List<DrugListItem> get items => _items;

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
    this.analytics,
    this._drugs,
  ) : _filteredDrugs = _drugs {
    sendScreenAnalytics();
  }

  @override
  Future<void> close() {
    _screenModeStreamController.close();
    return super.close();
  }

  @override
  DrugListState get initialState => _buildState();

  DrugListState _buildState() {
    // Sorting uses the default [Comparator]. See [Drug.compareTo] for more info.
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
      isEmpty: _drugs.isEmpty,
      screenMode: _screenMode,
      bottomBarKey: _bottomBarKey,
      items: _items,
      numberOfItemsTotal: numberOfItemsTotal,
      numberOfItemsSelected:
          _localizations.drugListTotalItemsSelected(selectedItemsCount),
      isDeleteButtonActive: selectedItemsCount > 0,
    );
  }

  List<DrugListItem> _buildItems(List<Drug> drugs) {
    final expired = drugs.where(_isDrugExpired).toList();
    final notExpired = drugs.where((e) => !_isDrugExpired(e)).toList();
    final result = <DrugListItem>[];
    if (expired.isNotEmpty) {
      result.addAll(
        _buildGroup(
          expired,
          _localizations.drugListExpiredGroupTitle.toUpperCase(),
          true,
        ),
      );
    }
    if (notExpired.isNotEmpty) {
      result.addAll(
        _buildGroup(
          notExpired,
          _localizations.drugListNotExpiredGroupTitle.toUpperCase(),
          false,
        ),
      );
    }
    return result;
  }

  List<DrugListItem> _buildGroup(
      List<Drug> drugs, String groupTitle, bool isExpired) {
    final group = DrugListHeadingItem(
      name: groupTitle,
    );
    final items = drugs
        .map(
          (e) => DrugListRowItem(
            group: group,
            id: e.id,
            name: e.name,
            formattedExpiresOn: expiresOnDateFormat.format(e.expiresOn),
            isExpired: isExpired,
          ),
        )
        .toList();
    group.items = items;
    return [
      group,
      ...items,
    ];
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
    for (final item in _items) {
      item.toggleSelection(isSelected: false);
    }
    yield _buildState();
  }

  Stream<DrugListState> _mapItemSelectionToggledEventToState(
    DrugListItemSelectionToggled event,
  ) async* {
    final item = event.item;
    item.toggleSelection(isSelected: !item.isSelected);
    _updateBottomBarDeleteButtonColor();
    yield _buildState();
    final group = item.group;
    group.toggleSelection(isSelected: group.areAllItemsSelected);
  }

  Stream<DrugListState> _mapGroupSelectionToggledEventToState(
    DrugListGroupSelectionToggled event,
  ) async* {
    final group = event.group;
    group.toggleSelection(isSelected: !group.isSelected);
    for (final item in group.items) {
      item.toggleSelection(isSelected: group.isSelected);
    }
    _updateBottomBarDeleteButtonColor();
    yield _buildState();
  }

  Stream<DrugListState> _mapItemDeletedEventToState(
    DrugListItemDeleted event,
  ) async* {
    try {
      await _repository.delete([event.id]);
      _filteredDrugs.removeWhere((element) => element.id == event.id);
      sendScreenAnalytics();
      yield _buildState();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<DrugListState> _mapSelectedItemsDeletedEventToState(
    DrugListSelectedItemsDeleted event,
  ) async* {
    try {
      final idsToDelete = _items
          .where((e) => e.isSelected && e is DrugListHeadingItem)
          .map((e) => e.id)
          .toList();
      await _repository.delete(idsToDelete);
      _items = _items.where((e) => !e.isSelected).toList();
      _setScreenMode(ScreenMode.normal);
      _updateBottomBarDeleteButtonColor();
      sendScreenAnalytics();
      yield _buildState();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<DrugListState> _mapAddingStartedEventToState(
    DrugListAddingStarted event,
  ) async* {
    final drug =
        await _navigatorKey.currentState.pushNamed<Drug>(AppRoutes.manageDrug);
    if (drug != null) {
      _filteredDrugs.add(drug);
      _filteredDrugs.sort();
      _items = _buildItems(_filteredDrugs);
      sendScreenAnalytics();
      yield _buildState();
    }
  }

  Stream<DrugListState> _mapEditingStartedEventToState(
    DrugListEditingStarted event,
  ) async* {
    final index = _filteredDrugs.indexWhere((drug) => drug.id == event.id);
    if (index == -1) {
      debugPrint('Unable edit a drug ${event.id}: unable to find its index');
      return;
    }
    final selectedDrug = _filteredDrugs[index];
    final drug = await _navigatorKey.currentState
        .pushNamed<Drug>(AppRoutes.manageDrug, arguments: selectedDrug);
    if (drug != null) {
      _filteredDrugs[index] = drug;
      _filteredDrugs.sort();
      _items = _buildItems(_filteredDrugs);
      sendScreenAnalytics();
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
    _items = _buildItems(_filteredDrugs);
    yield _buildState();
  }

  int _calculateSelectedItemsCount() =>
      _items.where((e) => e is DrugListRowItem && e.isSelected).length;

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
}
