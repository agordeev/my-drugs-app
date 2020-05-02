import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/models/drug.dart';
import 'package:uuid/uuid.dart';

part 'manage_drug_event.dart';
part 'manage_drug_state.dart';

class ManageDrugBloc extends Bloc<ManageDrugEvent, ManageDrugState> {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AbstractDrugRepository _repository;
  final Drug _drug;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _expiresOnController = TextEditingController();

  final _dateFormat = DateFormat('MM/yyyy');

  ManageDrugBloc(
    this._navigatorKey,
    this._repository,
    this._drug,
  );

  @override
  ManageDrugState get initialState {
    if (_drug != null) {
      _nameController.text = _drug.name;
      _expiresOnController.text = _dateFormat.format(_drug.expiresOn);
    }
    return ManageDrugInitial(
      _formKey,
      _nameController,
      _expiresOnController,
      _dateFormat.format(
        DateTime.utc(2020, 5, 30),
      ),
    );
  }

  @override
  Stream<ManageDrugState> mapEventToState(
    ManageDrugEvent event,
  ) async* {
    if (event is ManageDrugDrugStored) {
      yield* _mapDrugStoredEventToState();
    }
  }

  Stream<ManageDrugState> _mapDrugStoredEventToState() async* {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final context = _formKey.currentState.context;
    FocusScope.of(context).unfocus();
    try {
      final expiresOn = _dateFormat.parse('_expiresOnController.text');
      final drug = Drug(
        id: _drug?.id ?? Uuid().v4(),
        name: _nameController.text,
        expiresOn: expiresOn,
        createdAt: _drug?.createdAt ?? DateTime.now(),
      );
      final storedDrug = await _repository.store(drug);
      _navigatorKey.currentState.pop(storedDrug);
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
        content: Text(e.toString()),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: 'Close',
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
        ),
        behavior: SnackBarBehavior.floating,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
