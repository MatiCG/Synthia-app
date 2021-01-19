import 'package:flutter/material.dart';
import 'package:synthiaapp/Views/root.dart';
import 'package:synthiaapp/Views/login.dart';

import 'Classes/auth.dart';

void main() => runApp(SynthiaApp());

class SynthiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synthia',
      theme: ThemeData(primaryColor: Colors.blue),
      home: AuthConroller(),
    );
  }
}

class AuthConroller extends StatefulWidget {
  AuthConroller() : super();

  _AuthStatusState createState() => _AuthStatusState();
}

class _AuthStatusState extends State<AuthConroller> {
  String _auth;

  void _updateAuthStatus() async {
    String authStatus = await Auth().userStatus();
    setState(() {
      _auth = authStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: (new Auth()).userStatus(),
      builder: (context, snapshot) {
        _auth = snapshot.data;
//        Auth().signOut();
        switch (_auth) {
          case 'SIGNEDIN':
            return RootPage();
          case 'NOTSIGNEDIN':
            return LoginPage(
              authStatusController: () => _updateAuthStatus(),
            );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
