import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'manage_drug_event.dart';
part 'manage_drug_state.dart';

class ManageDrugBloc extends Bloc<ManageDrugEvent, ManageDrugState> {
  @override
  ManageDrugState get initialState => ManageDrugInitial();

  @override
  Stream<ManageDrugState> mapEventToState(
    ManageDrugEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
