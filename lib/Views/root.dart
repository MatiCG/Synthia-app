import 'package:flutter/material.dart';
import 'package:synthiaapp/Controllers/root.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class RootPage extends StatefulWidget {
  RootPage() : super();

  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  static final RootController _controller = RootController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.getPages()[_controller.getPageIndex()],
      bottomNavigationBar: buildFfNavigationBar(context),
    );
  }

  /// Build the bottom navigation bar for the entire app
  FFNavigationBar buildFfNavigationBar(BuildContext context) {
    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        barBackgroundColor: Colors.white,
        selectedItemBorderColor: Colors.transparent,
        selectedItemBackgroundColor: Theme.of(context).accentColor,
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.black,
        showSelectedItemShadow: false,
      ),
      selectedIndex: _controller.getPageIndex(),
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
          _controller.updatePageIndex(value);
        });
      },
    );
  }
}
