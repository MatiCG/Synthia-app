/// This screen allow the user to show if he want to sign-in or
/// to register.
/// He land on this screen only if is not sign-in
/// WARNING: We're using a streambuilder to change screens instead of
/// Navigator because we are using a streambuilder in the auth_controller.dart
/// and if a screen is pushed that create a issues (not refreshing without
/// a Navigator.pop)

import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/Authentification/home_auth.dart';
import 'package:synthiapp/Views/Authentification/register.dart';
import 'package:synthiapp/Widgets/splashscreen.dart';
import '../../Widgets/button.dart';
import 'login.dart';

class HomeAuthScreen extends StatefulWidget {
  const HomeAuthScreen() : super();

  @override
  _HomeAuthScreenState createState() => _HomeAuthScreenState();
}

class _HomeAuthScreenState extends State<HomeAuthScreen> {
  final HomeAuthController controller = HomeAuthController();

  @override
  void dispose() {
    super.dispose();

    controller.streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.streamController.stream,
      builder: (context, snapshot) {
        Widget selectedWiget = SplashScreen();

        if (!snapshot.hasData) return SplashScreen();
        switch (snapshot.data) {
          case screenStatus.home:
            selectedWiget = LandingPage(controller: controller);
            break;
          case screenStatus.login:
            selectedWiget = LoginPage(
              streamController: controller.streamController,
            );
            break;
          case screenStatus.register:
            selectedWiget = RegisterPage(
              streamController: controller.streamController,
            );
            break;
        }

        return selectedWiget;
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  LandingPage({required this.controller}) : super();

  final HomeAuthController controller;

  // Color for the gradient background [identical to the
  // splashscreen background]
  final List<Color> gradientColors = [
    const Color.fromRGBO(49, 115, 216, 1),
    const Color.fromRGBO(34, 136, 255, 1),
    const Color.fromRGBO(49, 115, 216, 1),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            buildAppLogo(screenHeight, screenWidth),
            Positioned(
              bottom: 16,
              child: Column(
                children: [
                  SynthiaButton(
                    text: 'Démarrer',
                    onPressed: () {
                      controller.register();
                    },
                  ),
                  SynthiaButton(
                    textOnly: true,
                    text: 'Connexion',
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      controller.login();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildAppLogo(double screenHeight, double screenWidth) {
    return Positioned(
      top: screenHeight * 0.3,
      child: Image(
        height: screenHeight * 0.4,
        width: screenWidth * 0.4,
        image: const AssetImage('assets/logo.png'),
      ),
    );
  }
}
