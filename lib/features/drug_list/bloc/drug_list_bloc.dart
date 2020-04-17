import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/models/drug.dart';

part 'drug_list_event.dart';
part 'drug_list_state.dart';

enum ScreenMode { normal, edit }

class DrugListBloc extends Bloc<DrugListEvent, DrugListState> {
  final AbstractDrugRepository _repository;
  List<Drug> _drugs;
  List<String> _selectedDrugsIds = [];

  final DateFormat _dateFormat = DateFormat('MMM yyyy');
  ScreenMode _screenMode = ScreenMode.normal;
  StreamController<ScreenMode> _screenModeStreamController =
      StreamController<ScreenMode>.broadcast();
  Stream<ScreenMode> get screenMode => _screenModeStreamController.stream;

  DrugListBloc(
    this._repository,
    this._drugs,
  );

  @override
  Future<void> close() {
    _screenModeStreamController.close();
    return super.close();
  }

  @override
  DrugListState get initialState => _buildState();

  DrugListState _buildState() => _drugs.isEmpty
      ? DrugListEmpty()
      : DrugListLoaded(
          _screenMode,
          _buildListItems(),
          '${_drugs.length} items',
          '${_selectedDrugsIds.length} selected',
          _selectedDrugsIds.isNotEmpty,
        );

  List<DrugListItem> _buildListItems() {
    List<DrugListItem> result = [];
    List<Drug> expired = [];
    List<Drug> notExpired = [];
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    _drugs.forEach((e) {
      if (e.expiresOn.compareTo(firstDayOfCurrentMonth) > 0) {
        notExpired.add(e);
      } else {
        expired.add(e);
      }
    });
    if (expired.isNotEmpty) {
      result.add(
        DrugHeadingItem('EXPIRED'),
      );
      result.addAll(
        expired.map(
          (e) => DrugItem(
            e.id,
            e.name,
            _dateFormat.format(e.expiresOn),
          ),
        ),
      );
    }
    if (notExpired.isNotEmpty) {
      result.add(
        DrugHeadingItem('NOT EXPIRED'),
      );
      result.addAll(
        notExpired.map(
          (e) => DrugItem(
            e.id,
            e.name,
            _dateFormat.format(e.expiresOn),
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
      _selectedDrugsIds = [];
      _screenModeStreamController.add(_screenMode);
      yield _buildState();
    } else if (event is SelectDeselectDrug) {
      if (event.isSelected) {
        _selectedDrugsIds.add(event.id);
      } else {
        _selectedDrugsIds.remove(event.id);
      }
      yield _buildState();
    }
  }
}
