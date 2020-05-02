import 'package:flutter/material.dart';

class RequiredFieldValidator {
  RequiredFieldValidator._();

  /// Returns error message if the value is invalid.
  /// Otherwise returns [null].
  static String validate(BuildContext context, dynamic value) {
    final errorMessage = 'Please fill this field';
    if (value == null) {
      return errorMessage;
    }
    if (value is String && value.isEmpty) {
      return errorMessage;
    }
    return null;
  }
}
