import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/transitions/down_to_up.dart';
import 'package:synthiapp/Animations/transitions/right_to_left.dart';

enum Transitions {
  UP_TO_DOWN,
  RIGHT_TO_LEFT,
}

extension TransitionExtensions on Transitions {
  of(screen) {
    switch (this) {
      case Transitions.UP_TO_DOWN:
        return UpToDown(screen: screen).transition;
      case Transitions.RIGHT_TO_LEFT:
        return RightToLeft(screen: screen).transition;
    }
  }
}

class ScreenTransition {
  getTransitionByName(Transitions transition, Widget screen) {
    return transition.of(screen);
  }
}
