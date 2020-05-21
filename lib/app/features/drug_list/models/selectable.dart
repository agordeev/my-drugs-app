import 'package:flutter/material.dart';

/// Incorporates selection/unselection logic.
abstract class Selectable {
  bool isSelected = false;
  AnimationController get checkmarkAnimationController;

  void deselect() {
    toggleSelection(false);
  }

  void select() {
    toggleSelection(true);
  }

  void toggleSelection(bool isSelected) {
    this.isSelected = isSelected;
    isSelected
        ? checkmarkAnimationController.forward()
        : checkmarkAnimationController.reverse();
  }
}
