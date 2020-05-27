part of 'drug_list_bloc.dart';

abstract class DrugListState extends Equatable {
  const DrugListState();
}

class DrugListInitial extends DrugListState {
  final bool isEmpty;
  final ScreenMode screenMode;
  final GlobalKey<DrugListBottomBarState> bottomBarKey;
  final List<DrugListItem> items;
  final String numberOfItemsTotal;
  final String numberOfItemsSelected;
  final bool isDeleteButtonActive;

  const DrugListInitial({
    this.isEmpty,
    this.screenMode,
    this.bottomBarKey,
    this.items,
    this.numberOfItemsTotal,
    this.numberOfItemsSelected,
    this.isDeleteButtonActive,
  });

  @override
  List<Object> get props => [
        isEmpty,
        screenMode,
        bottomBarKey,
        items,
        numberOfItemsTotal,
        numberOfItemsSelected,
        isDeleteButtonActive,
      ];
}
