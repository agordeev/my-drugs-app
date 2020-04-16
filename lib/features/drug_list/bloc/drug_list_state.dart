part of 'drug_list_bloc.dart';

abstract class DrugListState extends Equatable {
  const DrugListState();
}

class DrugListEmpty extends DrugListState {
  @override
  List<Object> get props => [];
}

class DrugListLoaded extends DrugListState {
  final ScreenMode screenMode;
  final List<DrugListItem> items;
  final String numberOfItemsTotal;
  final String numberOfItemsSelected;
  final bool isDeleteButtonActive;

  DrugListLoaded(
    this.screenMode,
    this.items,
    this.numberOfItemsTotal,
    this.numberOfItemsSelected,
    this.isDeleteButtonActive,
  );

  @override
  List<Object> get props => [
        this.screenMode,
        this.items,
        this.numberOfItemsTotal,
        this.numberOfItemsSelected,
        this.isDeleteButtonActive,
      ];
}
