part of 'manage_drug_bloc.dart';

abstract class ManageDrugState extends Equatable {
  const ManageDrugState();
}

class ManageDrugInitial extends ManageDrugState {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController expiresOnController;
  final String expiresOnPlaceholderText;

  ManageDrugInitial(
    this.formKey,
    this.nameController,
    this.expiresOnController,
    this.expiresOnPlaceholderText,
  );

  @override
  List<Object> get props => [
        formKey,
        nameController,
        expiresOnController,
        expiresOnPlaceholderText,
      ];
}
