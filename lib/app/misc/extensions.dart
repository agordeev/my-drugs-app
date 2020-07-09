import 'package:flutter/material.dart';

extension CheckIfTablet on MediaQueryData {
  bool isTablet() => size.shortestSide < 600;
}
