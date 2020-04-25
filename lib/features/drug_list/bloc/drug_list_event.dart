part of 'drug_list_bloc.dart';

abstract class DrugListEvent extends Equatable {
  const DrugListEvent();
}

class SwitchScreenMode extends DrugListEvent {
  @override
  List<Object> get props => [];
}

class SelectDeselectDrug extends DrugListEvent {
  final DrugGroupItem item;

  SelectDeselectDrug(
    this.item,
  );

  @override
  List<Object> get props => [
        item,
      ];
}

class SelectDeselectGroup extends DrugListEvent {
  final DrugGroup group;

  SelectDeselectGroup(
    this.group,
  );

  @override
  List<Object> get props => [
        group,
      ];
}

class DeleteDrugGroupItem extends DrugListEvent {
  final DrugGroupItem item;
  final AnimatedListRemovedItemBuilder groupBuilder;
  final AnimatedListRemovedItemBuilder itemBuilder;

  DeleteDrugGroupItem(
    this.item,
    this.groupBuilder,
    this.itemBuilder,
  );

  @override
  List<Object> get props => [
        item,
        groupBuilder,
        itemBuilder,
      ];
}
