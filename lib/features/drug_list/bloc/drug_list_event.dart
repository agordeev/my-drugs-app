part of 'drug_list_bloc.dart';

abstract class DrugListEvent extends Equatable {
  const DrugListEvent();
}

class SwitchScreenMode extends DrugListEvent {
  @override
  List<Object> get props => [];
}

class SelectDeselectDrug extends DrugListEvent {
  final String id;
  final bool isSelected;

  SelectDeselectDrug(this.id, this.isSelected);

  @override
  List<Object> get props => [id, isSelected];
}
