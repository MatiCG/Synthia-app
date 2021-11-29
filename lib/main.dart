import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Widgets/provider.dart';
import 'package:synthiapp/Widgets/splashscreen.dart';
import 'package:synthiapp/config/config.dart';
import 'Widgets/auth_controller.dart';

void main() {
  runApp(SynthiaApp());
}

class SynthiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Synthia App',
        theme: theme.lightTheme,
        home: const InitializeFirebaseApp(),
      ),
    );
  }
}

class InitializeFirebaseApp extends StatefulWidget {
  const InitializeFirebaseApp() : super();

  @override
  _InitializeFirebaseAppState createState() => _InitializeFirebaseAppState();
}

class _InitializeFirebaseAppState extends State<InitializeFirebaseApp> {
  final Future<FirebaseApp> _initialization = Future.delayed(
      const Duration(seconds: 1), () => Firebase.initializeApp());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (!snapshot.hasError &&
              snapshot.connectionState == ConnectionState.done) {
            return const AuthController();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
