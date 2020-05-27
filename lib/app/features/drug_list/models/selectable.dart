import 'package:flutter/material.dart';

/// Incorporates selection/unselection logic.
abstract class Selectable {
  bool isSelected = false;
  AnimationController get checkmarkAnimationController;

  Selectable();

  void deselect() {
    toggleSelection(isSelected: false);
  }

  void select() {
    toggleSelection(isSelected: true);
  }

  void toggleSelection({bool isSelected}) {
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
