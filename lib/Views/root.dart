import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/screen_transition.dart';
import 'package:synthiapp/Classes/right.dart';
import 'package:synthiapp/Controllers/root.dart';
import 'package:synthiapp/Views/Screens/creation_meeting.dart';
import 'package:synthiapp/Widgets/nav_item.dart';
import 'package:synthiapp/config/config.dart';

class Root extends StatefulWidget {
  const Root() : super();

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final RootController _controller = RootController();

  int selectedPage = 0;

  @override
  void initState() {
    super.initState();

    user.messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (!user.hasRight(RightID.anyNotifications)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(event.notification!.body ?? '')));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: _controller.model.pages[selectedPage]['page'] as Widget,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () => utils.pushScreenTransition(
            context, const CreationMeetingPage(), Transitions.upToDown),
        backgroundColor: Theme.of(context).accentColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<dynamic> _buildNavItems() {
    final List<dynamic> items = [];

    _controller.model.pages.asMap().forEach((index, page) {
      if (page.isEmpty) {
        items.add(
          const SizedBox(width: 48),
        );
      } else {
        items.add(NavItem(
          title: page['title'] as String,
          icon: (selectedPage == index ? page['selected_icon'] : page['icon'])
              as IconData,
          isSelected: selectedPage == index,
          onTap: () {
            setState(() {
              selectedPage = index;
            });
          },
        ));
      }
    });

    return items;
  }

  Widget _buildBottomNavigationBar() {
    final List<dynamic> items = _buildNavItems();

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          items.length,
          (index) => items[index] as Widget,
        ),
      ),
    );
  }
}
