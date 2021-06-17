import 'package:flutter/material.dart';

class SynthiaTheme extends ChangeNotifier {
  ThemeData get lightTheme {
    const Color gradientBlue = Color.fromRGBO(49, 115, 216, 1.0);
    const Color accentColor = Color.fromRGBO(34, 136, 255, 1.0);

    return ThemeData(
      scaffoldBackgroundColor: gradientBlue,
      primaryColor: Colors.white,
      accentColor: accentColor,
      bottomAppBarColor: Colors.white,
      canvasColor: Colors.transparent,
    );
  }
}
