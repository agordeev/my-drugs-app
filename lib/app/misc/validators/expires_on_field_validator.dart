import 'package:flutter/material.dart';
import 'package:my_drugs/generated/l10n.dart';

class ExpiresOnFieldValidator {
  ExpiresOnFieldValidator._();

  /// Returns error message if the value is invalid.
  /// Otherwise returns [null].
  static String validate(BuildContext context, String value) {
    if (value == null || value.isEmpty) {
      return S.of(context).validationEmptyRequiredField;
    }
    final delimeter = S.of(context).dateDelimeter;
    final regexp = RegExp('(0[1-9]|10|11|12)${delimeter}20[0-9]{2}\$');
    if (!regexp.hasMatch(value)) {
      return S.of(context).validationInvalidExpiryDate;
    }
    return null;
  }
}
