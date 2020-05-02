import 'package:flutter/material.dart';

class ExpiresOnFieldValidator {
  ExpiresOnFieldValidator._();

  /// Returns error message if the value is invalid.
  /// Otherwise returns [null].
  static String validate(BuildContext context, String value) {
    if (value == null || value.isEmpty) {
      return 'Please fill this field';
    }
    final regexp = RegExp(r'(0[1-9]|10|11|12)/20[0-9]{2}$');
    if (!regexp.hasMatch(value)) {
      return 'Please enter a valid expiry date';
    }
    return null;
  }
}
