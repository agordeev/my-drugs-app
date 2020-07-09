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

  const DrugListItemSelectionToggled(
    this.item,
  );

  @override
  List<Object> get props => [
        item,
      ];
}

class DrugListGroupSelectionToggled extends DrugListEvent {
  final DrugListHeadingItem group;

  const DrugListGroupSelectionToggled(
    this.group,
  );

  @override
  List<Object> get props => [
        group,
      ];
}

class DrugListItemDeleted extends DrugListEvent {
  final String id;

  const DrugListItemDeleted(
    this.id,
  );

  @override
  List<Object> get props => [
        id,
      ];
}

class DrugListSelectedItemsDeleted extends DrugListEvent {
  const DrugListSelectedItemsDeleted();

  @override
  List<Object> get props => [];
}

class DrugListAddingStarted extends DrugListEvent {
  const DrugListAddingStarted();

  @override
  List<Object> get props => [];
}

class DrugListEditingStarted extends DrugListEvent {
  final String id;

  const DrugListEditingStarted(this.id);

  @override
  List<Object> get props => [id];
}

class DrugListSearchTextFieldUpdated extends DrugListEvent {
  final String text;

  const DrugListSearchTextFieldUpdated(
    this.text,
  );

  @override
  List<Object> get props => [
        text,
      ];
}
