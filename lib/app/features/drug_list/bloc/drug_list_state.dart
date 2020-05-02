part of 'drug_list_bloc.dart';

abstract class DrugListState extends Equatable {
  const DrugListState();
}

class DrugListInitial extends DrugListState {
  final bool isEmpty;
  final ScreenMode screenMode;
  final GlobalKey<DrugListBottomBarState> bottomBarKey;
  final GlobalKey<AnimatedListState> listKey;
  final List<DrugGroup> groups;
  final String numberOfItemsTotal;
  final String numberOfItemsSelected;
  final bool isDeleteButtonActive;

  DrugListInitial(
    this.isEmpty,
    this.screenMode,
    this.bottomBarKey,
    this.listKey,
    this.groups,
    this.numberOfItemsTotal,
    this.numberOfItemsSelected,
    this.isDeleteButtonActive,
  );

  @override
  List<Object> get props => [
        isEmpty,
        screenMode,
        bottomBarKey,
        listKey,
        groups,
        numberOfItemsTotal,
        numberOfItemsSelected,
        isDeleteButtonActive,
      ];
}
