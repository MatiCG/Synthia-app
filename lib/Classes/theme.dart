import 'package:flutter/material.dart';

class SynthiaTheme extends ChangeNotifier {
  ThemeData get lightTheme {
    Color gradientBlue = Color.fromRGBO(49, 115, 216, 1.0);
    Color accentColor = Color.fromRGBO(34, 136, 255, 1.0);

    return ThemeData(
      scaffoldBackgroundColor: gradientBlue,
      primaryColor: Colors.white,
      accentColor: accentColor,
      bottomAppBarColor: Colors.white,
      canvasColor: Colors.transparent,
    );
  }
}
