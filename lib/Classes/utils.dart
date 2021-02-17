import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Save string into SharedPreferences
  void addStringToSF(String _key, String _value) async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    sf.setString(_key, _value);
  }

  // Retrieve string value from SharedPreferences
  Future<String> getStringToSF(String _key) async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getString(_key);
  }
}
