import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/transitions/down_to_up.dart';
import 'package:synthiapp/Animations/transitions/right_to_left.dart';

enum Transitions {
  upToDown,
  rightToLeft,
}

extension TransitionExtensions on Transitions {
  PageRouteBuilder of(Widget screen) {
    switch (this) {
      case Transitions.upToDown:
        return UpToDown(screen: screen).transition;
      case Transitions.rightToLeft:
        return RightToLeft(screen: screen).transition;
    }
  }
}

class ScreenTransition {
  PageRouteBuilder getTransitionByName(Transitions transition, Widget screen) {
    return transition.of(screen);
  }
}
