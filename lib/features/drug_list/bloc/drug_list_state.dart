part of 'drug_list_bloc.dart';

abstract class DrugListState extends Equatable {
  const DrugListState();
}

class DrugListEmpty extends DrugListState {
  @override
  List<Object> get props => [];
}

class DrugListLoaded extends DrugListState {
  final List<DrugListItem> items;

  DrugListLoaded(
    this.items,
  );

  @override
  List<Object> get props => [
        this.items,
      ];
}
