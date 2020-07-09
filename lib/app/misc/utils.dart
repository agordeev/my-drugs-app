import 'package:flutter/material.dart';

bool isTablet() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide > 600;
}
