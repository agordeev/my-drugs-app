part of 'drug_list_bloc.dart';

abstract class DrugListState extends Equatable {
  const DrugListState();
}

class DrugListInitial extends DrugListState {
  @override
  List<Object> get props => [];
}
