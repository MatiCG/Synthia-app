import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:synthiaapp/Views/root.dart';
import 'package:synthiaapp/Views/login.dart';
import 'package:synthiaapp/config.dart';
import 'Classes/auth.dart';

void main() => runApp(SynthiaApp());

class SynthiaApp extends StatefulWidget {
  SynthiaApp() : super();

  _SynthiaAppState createState() => _SynthiaAppState();
}

class _SynthiaAppState extends State<SynthiaApp> {
  @override
  void initState() {
    super.initState();
    theme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return MaterialApp(
      title: 'Synthia',
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.currentTheme(),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AuthController();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class AuthController extends StatefulWidget {
  AuthController() : super();

  _AuthControllerState createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  StreamSubscription _streamSubscription;
  userAuthState _userStatus = userAuthState.NOT_CONNECTED;

  @override
  void initState() {
    super.initState();
    // Listening for a new value of the user status
    _streamSubscription = auth.stream.listen((value) {
      // Change the current value for the userStatus to update view and get
      // the page corresponding
      if (this.mounted) {
        setState(() {
          _userStatus = value;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Stop stream to avoid memory leaks
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    switch (_userStatus) {
      case userAuthState.CONNECTED:
        return RootPage();
      case userAuthState.NOT_CONNECTED:
        return LoginPage();
      default:
        return LoginPage();
    }
  }
}
