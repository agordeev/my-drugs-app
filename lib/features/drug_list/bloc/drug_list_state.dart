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
  final GlobalKey<DrugListBottomBarState> bottomBarKey;
  final GlobalKey<AnimatedListState> listKey;
  final List<DrugGroup> groups;
  final String numberOfItemsTotal;
  final String numberOfItemsSelected;
  final bool isDeleteButtonActive;

  DrugListLoaded(
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
        this.screenMode,
        this.bottomBarKey,
        this.listKey,
        this.groups,
        this.numberOfItemsTotal,
        this.numberOfItemsSelected,
        this.isDeleteButtonActive,
      ];
}
