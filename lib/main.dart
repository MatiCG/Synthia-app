import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:synthiaapp/Pages/Settings.dart';
import 'package:synthiaapp/Widgets/LocalNotifications.dart';
import 'root_page.dart';
import 'auth.dart';
// Import pages for navBar
import 'Pages/HomePage.dart';
import 'Pages/AccountPage.dart';
//import 'Pages/TestPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synthia App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: new Auth()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.auth, this.onSignOut})
      : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(auth: auth, onSignOut: onSignOut);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.auth, this.onSignOut});

  final BaseAuth auth;
  final VoidCallback onSignOut;
  int selectedPage = 0;
  static List<Widget> pages;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  BottomNavigationBarItem createBNBitem(title, icon) {
    var bottomNavigationBarItem = BottomNavigationBarItem(
      title: Text(title),
      icon: Icon(icon),
    );
    return bottomNavigationBarItem;
  }

  @override
  void initState() {
    super.initState();

    _saveDeviceToken();
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      var test = LocalNotifications();
      test.showNotification(message['notification']['title'], message['notification']['body']);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
    }, onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
    });

    pages = [
      ListPage(),
      AccountPage(onSignOut: widget.onSignOut),
//      TestPage(),
      SettingsPage(onSignOut: widget.onSignOut),
    ];
  }

  _saveDeviceToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String token = await _fcm.getToken();

    if (token != null) {
      var tokenRef = _db
          .collection('users')
          .document(user.uid)
          .collection('tokens')
          .document(token);
      await tokenRef.setData({
        'token': token,
        'createAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
/*
    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }
    }
*/
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: pages.elementAt(selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          createBNBitem('home', Icons.home),
          createBNBitem('account', Icons.account_box),
//          createBNBitem('mail test', Icons.mail),
          createBNBitem('settings', Icons.settings),
        ],
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}

