import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/models/drug.dart';

part 'drug_list_event.dart';
part 'drug_list_state.dart';

enum ScreenMode { normal, edit }

class DrugListBloc extends Bloc<DrugListEvent, DrugListState> {
  final AbstractDrugRepository _repository;
  final List<Drug> _expiredDrugs;
  final List<Drug> _notExpiredDrugs;
  Set<String> _selectedDrugsIds = Set();

  /// Items that are currently displaying on DrugListScreen.
  List<DrugListItem> _listItems;

  final DateFormat _dateFormat = DateFormat('MMM yyyy');
  ScreenMode _screenMode = ScreenMode.normal;
  StreamController<ScreenMode> _screenModeStreamController =
      StreamController<ScreenMode>.broadcast();
  Stream<ScreenMode> get screenMode => _screenModeStreamController.stream;

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
      if (_listItems == null) {
        _listItems = _buildListItems(_expiredDrugs, _notExpiredDrugs);
      }
      return DrugListLoaded(
        _screenMode,
        _listItems,
        '${(_expiredDrugs.length + _notExpiredDrugs.length)} items',
        '${_selectedDrugsIds.length} selected',
        _selectedDrugsIds.isNotEmpty,
      );
    }
  }

  List<DrugListItem> _buildListItems(
      List<Drug> expired, List<Drug> notExpired) {
    List<DrugListItem> result = [];
    if (expired.isNotEmpty) {
      result.add(
        DrugHeadingItem(
          GlobalKey(),
          true,
        ),
      );
      result.addAll(
        expired.map(
          (e) => DrugItem(
            GlobalKey(),
            e.id,
            e.name,
            _dateFormat.format(e.expiresOn),
            true,
          ),
        ),
      );
    }
    if (notExpired.isNotEmpty) {
      result.add(
        DrugHeadingItem(
          GlobalKey(),
          false,
        ),
      );
      result.addAll(
        notExpired.map(
          (e) => DrugItem(
            GlobalKey(),
            e.id,
            e.name,
            _dateFormat.format(e.expiresOn),
            false,
          ),
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
      if (_screenMode == ScreenMode.edit) {
        _screenMode = ScreenMode.normal;
      } else {
        _screenMode = ScreenMode.edit;
      }
      _selectedDrugsIds = Set();
      _screenModeStreamController.add(_screenMode);
      yield _buildState();
    } else if (event is SelectDeselectDrug) {
      yield* _mapSelectDeselectDrugEventToState(event);
    } else if (event is SelectDeselectGroup) {
      yield* _mapSelectDeselectGroupEventToState(event);
    }
  }

  Stream<DrugListState> _mapSelectDeselectDrugEventToState(
    SelectDeselectDrug event,
  ) async* {
    final list = event.item.isExpired ? _expiredDrugs : _notExpiredDrugs;
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
    // final nonSelectedItem = list.firstWhere((element) => !_selectedDrugsIds.contains(element.id),
    //     orElse: () => null);
    //     if (nonSelectedItem == null) {

    //     }
    yield _buildState();
  }

  Stream<DrugListState> _mapSelectDeselectGroupEventToState(
    SelectDeselectGroup event,
  ) async* {
    final list = event.item.isExpired ? _expiredDrugs : _notExpiredDrugs;
    // Should select if at least one drug from the group is not selected
    final shouldSelect = list.firstWhere(
            (element) => !_selectedDrugsIds.contains(element.id),
            orElse: () => null) !=
        null;
    if (shouldSelect) {
      event.item.key.currentState.checkmarkAnimationController.forward();
    } else {
      event.item.key.currentState.checkmarkAnimationController.reverse();
    }
    list.forEach((e) {
      if (shouldSelect) {
        _selectedDrugsIds.add(e.id);
      } else {
        _selectedDrugsIds.remove(e.id);
      }
      _listItems.forEach((element) {
        if (element is DrugItem && element.id == e.id) {
          if (shouldSelect) {
            element.key.currentState.checkmarkAnimationController.forward();
          } else {
            element.key.currentState.checkmarkAnimationController.reverse();
          }
        }
      });
    });
    yield _buildState();
  }
}
