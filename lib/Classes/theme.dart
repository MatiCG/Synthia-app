import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SynthiaTheme extends ChangeNotifier {
  static bool _isDark = false;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  FFNavigationBarTheme currentBottomNavBarTheme() {
    return _isDark ? darkBottomNavBar : lightBottomNavBar;
  }

  FFNavigationBarTheme get darkBottomNavBar {
    return FFNavigationBarTheme(
      barBackgroundColor: Colors.grey[800],
      selectedItemBorderColor: Colors.transparent,
      selectedItemBackgroundColor: Colors.blueGrey[600],
      selectedItemIconColor: Colors.white,
      selectedItemLabelColor: Colors.white,
      showSelectedItemShadow: false,
    );
  }

  FFNavigationBarTheme get lightBottomNavBar {
    return FFNavigationBarTheme(
      barBackgroundColor: Colors.white,
      selectedItemBorderColor: Colors.transparent,
      selectedItemBackgroundColor: Colors.cyan[900],
      selectedItemIconColor: Colors.white,
      selectedItemLabelColor: Colors.black,
      showSelectedItemShadow: false,
    );
  }

  ThemeData get darkTheme {
    Color primaryColor = Colors.grey[800];
    Color accentColor = Colors.blueGrey;

    return ThemeData(
      fontFamily: GoogleFonts.varelaRound().fontFamily,
      brightness: Brightness.dark,
      accentColor: accentColor,
      primaryColor: primaryColor,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w100,
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w100,
          color: Colors.black,
        ),
        headline1: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: primaryColor,
        ),
        headline2: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: accentColor,
        ),
        headline3: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: primaryColor,
        ),
        headline4: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: accentColor,
        ),
        headline5: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: primaryColor,
        ),
        headline6: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: accentColor,
        ),
      ),
    );
  }

  ThemeData get lightTheme {
    Color primaryColor = Colors.white;
    Color primaryColorDark = Colors.black;
    Color accentColor = Colors.cyan[900];

    return ThemeData(
      fontFamily: GoogleFonts.varelaRound().fontFamily,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      accentColor: accentColor,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w100,
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w100,
          color: Colors.black,
        ),
        headline1: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: primaryColor,
        ),
        headline2: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: accentColor,
        ),
        headline3: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: primaryColor,
        ),
        headline4: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: accentColor,
        ),
        headline5: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: primaryColor,
        ),
        headline6: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: accentColor,
        ),
      ),
    );
/*
    return ThemeData(
      fontFamily: GoogleFonts.varelaRound().fontFamily,
      brightness: Brightness.light,
      primaryColor: Colors.white,
      accentColor: Colors.cyan[900],
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        headline4: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.cyan[900],
        ),
        headline5:
            TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: this),
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.cyan[900],
        ),
      ),
    );
*/
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
