import 'package:flutter/material.dart';

/// All small functions are inside this class
class Utils {
  /// Future push screen
  Future<void> futurePushScreen(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  /// Push a new screen
  void pushScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
