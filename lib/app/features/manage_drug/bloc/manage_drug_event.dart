part of 'manage_drug_bloc.dart';

abstract class ManageDrugEvent extends Equatable {
  const ManageDrugEvent();
}

class ManageDrugDrugStored extends ManageDrugEvent {
  @override
  List<Object> get props => [];
}
