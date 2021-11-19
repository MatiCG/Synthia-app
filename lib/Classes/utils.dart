import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/screen_transition.dart';

/// All small functions are inside this class
class Utils {
  /// Future push screen
  Future futurePushScreen(BuildContext context, Widget screen) async {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Push a new screen  with a specific transition
  void pushScreenTransition(
      BuildContext context, Widget screen, Transitions transition) {
    Navigator.of(context)
        .push(ScreenTransition().getTransitionByName(transition, screen));
  }

  /// Push a new screen
  void pushScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Push a new screen as first in stack
  void pushReplacementScreen(BuildContext context, Widget screen,
      {Duration duration = const Duration()}) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: duration,
      ),
      /*
      MaterialPageRoute(builder: (context) => screen, ),
      */
    );
  }

  /// Update something in the view with the given parent
  ///
  /// Check automatticaly if the parent is mounted
  void updateView(State<StatefulWidget> parent, {Function? update}) {
    if (parent.mounted && update != null) {
      // ignore: invalid_use_of_protected_member
      parent.setState(() {
        update();
      });
    }
  }

  String parseTime(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }
}
