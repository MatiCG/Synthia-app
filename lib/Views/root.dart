import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:synthiaapp/Controllers/root.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:synthiaapp/Widgets/notifications.dart';
import 'package:synthiaapp/config.dart';

class RootPage extends StatefulWidget {
  RootPage() : super();

  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  static RootController _controller;
//  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _controller = RootController();

    PushNotificationsHandler().init();
/*
    try {
      _fcm.getInitialMessage().then((value) {
        if (value == null) {
          print('EMPTY mdjsk fljsdflk jsdflk jsfl ');
        } else {
          print('Init message: ' + value.toString());
        }
      });
    } catch (e) {
      print('Error: ' + e.toString());
    }
    // Configure notifications
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('New message: ' + message.toString());
        LocalNotifications localNotifications = LocalNotifications();
        localNotifications.showNotification(
            message.toString(), message.toString());
      });
    } catch (e) {
      print('Other error : ' + e.toString());
    }
*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.getPages()[_controller.model.pageIndex],
      bottomNavigationBar: buildFfNavigationBar(context),
    );
  }

  /// Build the bottom navigation bar for the entire app
  FFNavigationBar buildFfNavigationBar(BuildContext context) {
    return FFNavigationBar(
      theme: theme.currentBottomNavBarTheme(),
      selectedIndex: _controller.model.pageIndex,
      items: [
        FFNavigationBarItem(
          iconData: Icons.home,
          label: 'Home',
        ),
        FFNavigationBarItem(
          iconData: Icons.person,
          label: 'Account',
        ),
        FFNavigationBarItem(
          iconData: Icons.settings,
          label: 'Settings',
        ),
      ],
      onSelectTab: (value) {
        setState(() {
          _controller.model.pageIndex = value;
        });
      },
    );
  }
}
