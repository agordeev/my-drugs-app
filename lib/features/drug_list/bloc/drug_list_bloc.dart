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
  Set<String> _selectedDrugsIds = Set();

  List<DrugGroup> _groups;

  final DateFormat _dateFormat = DateFormat('MMM yyyy');
  ScreenMode _screenMode = ScreenMode.normal;
  StreamController<ScreenMode> _screenModeStreamController =
      StreamController<ScreenMode>.broadcast();
  Stream<ScreenMode> get screenMode => _screenModeStreamController.stream;

  final GlobalKey<DrugListBottomBarState> _bottomBarKey = GlobalKey();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

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
    if (_expiredDrugs.isEmpty && _notExpiredDrugs.isEmpty) {
      return DrugListEmpty();
    } else {
      if (_groups == null) {
        _groups = _buildGroups(_expiredDrugs, _notExpiredDrugs);
      }
      return DrugListLoaded(
        _screenMode,
        _bottomBarKey,
        _listKey,
        _groups,
        '${(_expiredDrugs.length + _notExpiredDrugs.length)} items',
        '${_selectedDrugsIds.length} selected',
        _selectedDrugsIds.isNotEmpty,
      );
    }
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
                ),
              )
              .toList(),
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
                ),
              )
              .toList(),
        ),
      );
    }
    return result;
  }

  @override
  Stream<DrugListState> mapEventToState(
    DrugListEvent event,
  ) async* {
    if (event is SwitchScreenMode) {
      yield* _mapSwitchScreenModeEventToState();
    } else if (event is SelectDeselectDrug) {
      yield* _mapSelectDeselectDrugEventToState(event);
    } else if (event is SelectDeselectGroup) {
      yield* _mapSelectDeselectGroupEventToState(event);
    } else if (event is DeleteDrugGroupItem) {
      yield* _mapDeleteDrugGroupItemEventToState(event);
    }
  }

  Stream<DrugListState> _mapSwitchScreenModeEventToState() async* {
    if (_screenMode == ScreenMode.edit) {
      _screenMode = ScreenMode.normal;
    } else {
      _screenMode = ScreenMode.edit;
    }
    _selectedDrugsIds = Set();
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
    if (!_selectedDrugsIds.contains(event.item.id)) {
      // Add to selected.
      _selectedDrugsIds.add(event.item.id);
      // Animate checkmark to "ON".
      event.item.key.currentState.checkmarkAnimationController.forward();
    } else {
      _selectedDrugsIds.remove(event.item.id);
      event.item.key.currentState.checkmarkAnimationController.reverse();
    }
    // If all drugs from the current group are selected, then update group checkmark too.
    final areAllSelected = _areAllSelected(group);
    if (areAllSelected) {
      groupState.checkmarkAnimationController.forward();
    } else {
      groupState.checkmarkAnimationController.reverse();
    }
    if (_selectedDrugsIds.isNotEmpty) {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.forward();
    } else {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.reverse();
    }
    yield _buildState();
  }

  Stream<DrugListState> _mapSelectDeselectGroupEventToState(
    SelectDeselectGroup event,
  ) async* {
    // Should select if at least one drug from the group is not selected
    final shouldSelect = !_areAllSelected(event.group);
    if (shouldSelect) {
      event.group.key.currentState.checkmarkAnimationController.forward();
    } else {
      event.group.key.currentState.checkmarkAnimationController.reverse();
    }
    event.group.items.forEach((e) {
      if (shouldSelect) {
        _selectedDrugsIds.add(e.id);
        e.key.currentState.checkmarkAnimationController.forward();
      } else {
        _selectedDrugsIds.remove(e.id);
        e.key.currentState.checkmarkAnimationController.reverse();
      }
    });
    if (_selectedDrugsIds.isNotEmpty) {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.forward();
    } else {
      _bottomBarKey.currentState.deleteButtonColorAnimationController.reverse();
    }
    yield _buildState();
  }

  Stream<DrugListState> _mapDeleteDrugGroupItemEventToState(
    DeleteDrugGroupItem event,
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
      print('Item not found');
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
        duration: Duration(milliseconds: 300),
      );
    } else {
      group.items.remove(event.item);
      group.listKey.currentState.removeItem(
        itemIndex,
        event.itemBuilder,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  /// Returns [true] if all group items are selected. [false] otherwise.
  bool _areAllSelected(DrugGroup group) {
    final nonSelectedItem = group.items.firstWhere(
        (element) => !_selectedDrugsIds.contains(element.id),
        orElse: () => null);
    return nonSelectedItem == null;
  }
}
