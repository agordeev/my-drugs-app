import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drug_list_event.dart';
part 'drug_list_state.dart';

class DrugListBloc extends Bloc<DrugListEvent, DrugListState> {
  @override
  DrugListState get initialState => DrugListInitial();

  @override
  Stream<DrugListState> mapEventToState(
    DrugListEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
