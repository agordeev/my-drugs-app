part of 'drug_list_bloc.dart';

abstract class DrugListEvent extends Equatable {
  const DrugListEvent();
}

class SwitchScreenMode extends DrugListEvent {
  @override
  List<Object> get props => [];
}
