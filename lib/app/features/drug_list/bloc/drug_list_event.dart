part of 'drug_list_bloc.dart';

abstract class DrugListEvent extends Equatable {
  const DrugListEvent();
}

class DrugListScreenModeSwitched extends DrugListEvent {
  @override
  List<Object> get props => [];
}

class DrugListItemSelectionToggled extends DrugListEvent {
  final DrugListRowItem item;

  DrugListItemSelectionToggled(
    this.item,
  );

  @override
  List<Object> get props => [
        item,
      ];
}

class DrugListGroupSelectionToggled extends DrugListEvent {
  final DrugListHeadingItem group;

  DrugListGroupSelectionToggled(
    this.group,
  );

  @override
  List<Object> get props => [
        group,
      ];
}

class DrugListItemDeleted extends DrugListEvent {
  final String id;

  DrugListItemDeleted(
    this.id,
  );

  @override
  List<Object> get props => [
        id,
      ];
}

class DrugListSelectedItemsDeleted extends DrugListEvent {
  DrugListSelectedItemsDeleted();

  @override
  List<Object> get props => [];
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

  DrugListSearchTextFieldUpdated(
    this.text,
  );

  @override
  List<Object> get props => [
        text,
      ];
}
