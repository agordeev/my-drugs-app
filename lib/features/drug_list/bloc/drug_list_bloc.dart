import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_heading_row_widget.dart';
import 'package:my_drugs/features/drug_list/widgets/drug_list_bottom_bar.dart';
import 'package:my_drugs/models/drug.dart';

part 'drug_list_event.dart';
part 'drug_list_state.dart';

enum ScreenMode { normal, edit }

class DrugListBloc extends Bloc<DrugListEvent, DrugListState> {
  final AbstractDrugRepository _repository;
  final List<Drug> _expiredDrugs;
  final List<Drug> _notExpiredDrugs;

  List<DrugGroup> _groups;
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

  final DateFormat _dateFormat = DateFormat('MMM yyyy');
  ScreenMode _screenMode = ScreenMode.normal;
  StreamController<ScreenMode> _screenModeStreamController =
      StreamController<ScreenMode>.broadcast();
  Stream<ScreenMode> get screenMode => _screenModeStreamController.stream;

  final GlobalKey<DrugListBottomBarState> _bottomBarKey = GlobalKey();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final Duration _animationDuration = Duration(milliseconds: 5000);

  static final _firstDayOfCurrentMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);

  DrugListBloc(
    this._repository,
    List<Drug> drugs,
  )   : _expiredDrugs = drugs
            .where((e) => e.expiresOn.compareTo(_firstDayOfCurrentMonth) <= 0)
            .toList(),
        _notExpiredDrugs = drugs
            .where((e) => e.expiresOn.compareTo(_firstDayOfCurrentMonth) > 0)
            .toList();

  @override
  Future<void> close() {
    _screenModeStreamController.close();
    return super.close();
  }

  @override
  DrugListState get initialState => _buildState();

  DrugListState _buildState() {
    if (_groups == null) {
      _groups = _buildGroups(_expiredDrugs, _notExpiredDrugs);
    }
    final selectedItemsCount = _selectedItemsCount;
    return DrugListInitial(
      _expiredDrugs.isEmpty && _notExpiredDrugs.isEmpty,
      _screenMode,
      _bottomBarKey,
      _listKey,
      _groups,
      '${(_expiredDrugs.length + _notExpiredDrugs.length)} items',
      '$selectedItemsCount selected',
      selectedItemsCount > 0,
    );
  }

  List<DrugGroup> _buildGroups(List<Drug> expired, List<Drug> notExpired) {
    List<DrugGroup> result = [];
    if (expired.isNotEmpty) {
      final groupKey = GlobalKey<DrugHeadingRowState>();
      result.add(
        DrugGroup(
          groupKey,
          GlobalKey(),
          'EXPIRED',
          expired
              .map(
                (e) => DrugGroupItem(
                  GlobalKey(),
                  groupKey,
                  e.id,
                  e.name,
                  _dateFormat.format(e.expiresOn),
                  false,
                ),
              )
              .toList(),
          false,
        ),
      );
    }
    if (notExpired.isNotEmpty) {
      final groupKey = GlobalKey<DrugHeadingRowState>();
      result.add(
        DrugGroup(
          groupKey,
          GlobalKey(),
          'NOT EXPIRED',
          notExpired
              .map(
                (e) => DrugGroupItem(
                  GlobalKey(),
                  groupKey,
                  e.id,
                  e.name,
                  _dateFormat.format(e.expiresOn),
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
    if (event is DrugListScreenModeSwitchd) {
      yield* _mapSwitchScreenModeEventToState();
    } else if (event is SelectDeselectDrug) {
      yield* _mapSelectDeselectDrugEventToState(event);
    } else if (event is DrugListGroupSelectionChanged) {
      yield* _mapSelectDeselectGroupEventToState(event);
    } else if (event is DrugListGroupItemDeleted) {
      yield* _mapDeleteDrugGroupItemEventToState(event);
    } else if (event is DrugListSelectedItemsDeleted) {
      yield* _mapDeleteSelectedItemsEventToState(event);
    }
  }

  Stream<DrugListState> _mapSwitchScreenModeEventToState() async* {
    if (_screenMode == ScreenMode.edit) {
      _screenMode = ScreenMode.normal;
    } else {
      _screenMode = ScreenMode.edit;
    }
    _groups.forEach((group) {
      group.isSelected = false;
      group.items.forEach((item) => item.isSelected = false);
    });
    _groups.forEach((group) {
      group.key.currentState.checkmarkAnimationController.reverse();
      group.items.forEach((item) =>
          item.key.currentState.checkmarkAnimationController.reverse());
    });
    _screenModeStreamController.add(_screenMode);
    yield _buildState();
  }

  Stream<DrugListState> _mapSelectDeselectDrugEventToState(
    SelectDeselectDrug event,
  ) async* {
    final groupState = event.item.groupKey.currentState;
    final group = _groups.firstWhere(
      (element) => element.key == event.item.groupKey,
      orElse: () => null,
    );
    if (group == null) {
      return;
    }
    // If not selected.
    if (!event.item.isSelected) {
      event.item.isSelected = true;
      // Animate checkmark to "ON".
      event.item.key.currentState.checkmarkAnimationController.forward();
    } else {
      event.item.isSelected = false;
      event.item.key.currentState.checkmarkAnimationController.reverse();
    }
    // If all drugs from the current group are selected, then update group checkmark too.
    final areAllSelected = group.items.length ==
        group.items.where((item) => item.isSelected).length;
    if (areAllSelected) {
      group.isSelected = true;
      groupState.checkmarkAnimationController.forward();
    } else {
      group.isSelected = false;
      groupState.checkmarkAnimationController.reverse();
    }
    if (_selectedItemsCount > 0) {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.forward();
    } else {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.reverse();
    }
    yield _buildState();
  }

  Stream<DrugListState> _mapSelectDeselectGroupEventToState(
    DrugListGroupSelectionChanged event,
  ) async* {
    event.group.isSelected = !event.group.isSelected;
    if (event.group.isSelected) {
      event.group.key.currentState.checkmarkAnimationController.forward();
    } else {
      event.group.key.currentState.checkmarkAnimationController.reverse();
    }
    event.group.items.forEach((item) {
      if (event.group.isSelected) {
        item.isSelected = true;
        item.key.currentState.checkmarkAnimationController.forward();
      } else {
        item.isSelected = false;
        item.key.currentState.checkmarkAnimationController.reverse();
      }
    });
    if (_selectedItemsCount > 0) {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.forward();
    } else {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.reverse();
    }
    yield _buildState();
  }

  Stream<DrugListState> _mapDeleteDrugGroupItemEventToState(
    DrugListGroupItemDeleted event,
  ) async* {
    int groupIndex = -1;
    int itemIndex = -1;
    for (var i = 0; i < _groups.length; i++) {
      final group = _groups[i];
      for (var j = 0; j < group.items.length; j++) {
        final item = group.items[j];
        if (item == event.item) {
          groupIndex = i;
          itemIndex = j;
          break;
        }
      }
      if (groupIndex != -1) {
        break;
      }
    }
    if (groupIndex == -1 || itemIndex == -1) {
      return;
    }
    _expiredDrugs.removeWhere((element) => element.id == event.item.id);
    _notExpiredDrugs.removeWhere((element) => element.id == event.item.id);
    final group = _groups[groupIndex];
    if (group.items.length == 1) {
      // The group will become empty after item removal. Delete the entire group.
      _groups.remove(group);

      _listKey.currentState.removeItem(
        groupIndex,
        event.groupBuilder,
        duration: _animationDuration,
      );
      if (_groups.isEmpty) {
        await Future.delayed(Duration(milliseconds: 300));
        yield _buildState();
      }
    } else {
      group.items.remove(event.item);
      group.listKey.currentState.removeItem(
        itemIndex,
        event.itemBuilder,
        duration: _animationDuration,
      );
    }
  }

  Stream<DrugListState> _mapDeleteSelectedItemsEventToState(
    DrugListSelectedItemsDeleted event,
  ) async* {
    int selectedGroupsCount = _groups.where((group) => group.isSelected).length;
    while (selectedGroupsCount > 0) {
      final index = _groups.indexWhere((group) => group.isSelected);
      final group = _groups.removeAt(index);
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
        int selectedItemsCount =
            group.items.where((item) => item.isSelected).length;
        while (selectedItemsCount > 0) {
          final index = group.items.indexWhere((item) => item.isSelected);
          final item = group.items.removeAt(index);
          group.listKey.currentState.removeItem(
            index,
            (context, animation) => event.itemBuilder(context, item, animation),
            duration: _animationDuration,
          );
          selectedItemsCount -= 1;
        }
      }
    }
  }
}
