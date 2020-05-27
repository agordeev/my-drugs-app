import 'package:flutter/material.dart';

/// Incorporates selection/unselection logic.
abstract class Selectable {
  bool isSelected;
  AnimationController get checkmarkAnimationController;

  Selectable(this.isSelected);

  void deselect() {
    toggleSelection(false);
  }

  void select() {
    toggleSelection(true);
  }

  void toggleSelection(bool isSelected) {
    this.isSelected = isSelected;
    if (checkmarkAnimationController == null) {
      // The item isn't currently visible on the screen.
      return;
    }
    isSelected
        ? checkmarkAnimationController.forward()
        : checkmarkAnimationController.reverse();
  }
}
