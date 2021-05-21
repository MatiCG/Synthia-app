import 'package:flutter/material.dart';

/// This is an extension of the splashscreen displayed
/// while we're checking the status of the user

class SplashScreen extends StatelessWidget {
  SplashScreen() : super();

  // Color for the gradient background [identical to the
  // splashscreen background]
  final List<Color> gradientColors = [
    Color.fromRGBO(49, 115, 216, 1),
    Color.fromRGBO(34, 136, 255, 1),
    Color.fromRGBO(49, 115, 216, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: Center(
          child: Image(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
            image: AssetImage('assets/logo.png'),
          ),
        ),
      ),
    );
  }
}
