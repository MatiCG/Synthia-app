import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:synthiaapp/Controllers/root.dart';

class RootPage extends StatefulWidget {
  RootPage() : super();

  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  static final RootController _controller = RootController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _controller.getPages()[_controller.getPageIndex()],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _controller.getPageIndex(),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Account'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        onItemSelected: (value) {
          setState(() {
            _controller.updatePageIndex(value);
          });
        },
      ),
    );
  }
}
