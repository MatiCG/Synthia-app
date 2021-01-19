import 'package:flutter/material.dart';

/// All small functions are inside this class
class Utils {
  /// Push a new screen
  void pushScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
