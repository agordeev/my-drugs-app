part of 'drug_list_bloc.dart';

abstract class DrugListEvent extends Equatable {
  const DrugListEvent();
}

class SwitchScreenMode extends DrugListEvent {
  @override
  List<Object> get props => [];
}

class SelectDeselectDrug extends DrugListEvent {
  final DrugItem item;

  SelectDeselectDrug(
    this.item,
  );

  @override
  List<Object> get props => [
        item,
      ];
}

class SelectDeselectGroup extends DrugListEvent {
  final DrugHeadingItem item;

  SelectDeselectGroup(
    this.item,
  );

  @override
  List<Object> get props => [
        item,
      ];
}
