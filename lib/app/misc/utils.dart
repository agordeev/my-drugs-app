import 'package:flutter/material.dart';

/// A max width of button or search bar.
const kElementMaxWidth = 440.0;

bool isTablet() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide >= 600;
}
