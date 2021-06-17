import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/circular_close.dart';
import 'package:synthiapp/Views/root.dart';
import 'package:synthiapp/config/config.dart';
import '../Views/Authentification/home_auth.dart';
import 'splashscreen.dart';

/// This widget send the user to the right screen if there are logged or not

class AuthController extends StatefulWidget {
  const AuthController() : super();

  @override
  _AuthControllerState createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {

  @override
  void initState() {
    super.initState();
    if (mounted) {
      user.searchRights.listen((right) {
        setState(() {
          user.addNewRight(right as String);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget selectedWidget = Scaffold(body: SplashScreen());
    return StreamBuilder(
      stream: user.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            selectedWidget = const Root();
          } else {
            selectedWidget = const HomeAuthScreen();
          }
        } else {
          selectedWidget = Scaffold(body: SplashScreen());
        }

        if (selectedWidget is! Root && selectedWidget is! SplashScreen) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: Tween(begin: 1.0, end: 1.0).animate(animation),
                child: child,
              );
            },
            layoutBuilder: (currentChild, previousChildren) {
              return currentChild!;
            },
            child: selectedWidget,
          );
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: Tween(begin: 1.0, end: 1.0).animate(animation),
                child: child,
              );
            },
            layoutBuilder: (currentChild, previousChildren) {
              if (currentChild != null && previousChildren.isNotEmpty) {
                return CircularCloseAnimation(
                  duration: const Duration(milliseconds: 500),
                  landingWidget: currentChild,
                  closeWidget: previousChildren[0],
                );
              }
              return currentChild!;
            },
            child: selectedWidget,
          );
        }
      },
    );
  }
}

class Test extends StatefulWidget {
  const Test() : super();

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    final String? test = user.data?.displayName;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bonjour ${test?.split(' ')[0] ?? 'error'}'),
            ElevatedButton(
              onPressed: user.signOut,
              child: const Text('Sign-out'),
            ),
          ],
        ),
      ),
    );
  }
}
