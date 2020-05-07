import 'package:flutter/material.dart';
import 'package:my_drugs/generated/l10n.dart';

class RequiredFieldValidator {
  RequiredFieldValidator._();

  /// Returns error message if the value is invalid.
  /// Otherwise returns [null].
  static String validate(BuildContext context, dynamic value) {
    final errorMessage = S.of(context).validationEmptyRequiredField;
    if (value == null) {
      return errorMessage;
    }
    if (value is String && value.isEmpty) {
      return errorMessage;
    }
    return null;
  }
}
