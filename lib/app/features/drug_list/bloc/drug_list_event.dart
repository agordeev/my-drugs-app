part of 'drug_list_bloc.dart';

abstract class DrugListEvent extends Equatable {
  const DrugListEvent();
}

class DrugListScreenModeSwitched extends DrugListEvent {
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

class DrugListGroupSelectionChanged extends DrugListEvent {
  final DrugItemGroup group;

  DrugListGroupSelectionChanged(
    this.group,
  );

  @override
  List<Object> get props => [
        group,
      ];
}

class DrugListGroupItemDeleted extends DrugListEvent {
  final DrugItemGroup group;
  final DrugItem item;
  final AnimatedListRemovedItemBuilder groupBuilder;
  final AnimatedListRemovedItemBuilder itemBuilder;

  DrugListGroupItemDeleted(
    this.group,
    this.item,
    this.groupBuilder,
    this.itemBuilder,
  );

  @override
  List<Object> get props => [
        group,
        item,
        groupBuilder,
        itemBuilder,
      ];
}

class DrugListSelectedItemsDeleted extends DrugListEvent {
  final Widget Function(BuildContext, DrugItemGroup, Animation<double>)
      groupBuilder;
  final Widget Function(BuildContext, DrugItem, Animation<double>) itemBuilder;

  DrugListSelectedItemsDeleted(
    this.groupBuilder,
    this.itemBuilder,
  );

  @override
  List<Object> get props => [
        groupBuilder,
        itemBuilder,
      ];
}

class DrugListAddingStarted extends DrugListEvent {
  DrugListAddingStarted();

  @override
  List<Object> get props => [];
}

class DrugListEditingStarted extends DrugListEvent {
  final String id;

  DrugListEditingStarted(this.id);

  @override
  List<Object> get props => [id];
}

class DrugListSearchTextFieldUpdated extends DrugListEvent {
  final String text;
  final Widget Function(BuildContext, DrugItem, Animation<double>) itemBuilder;

  DrugListSearchTextFieldUpdated(
    this.text,
    this.itemBuilder,
  );

  @override
  List<Object> get props => [
        text,
        itemBuilder,
      ];
}
