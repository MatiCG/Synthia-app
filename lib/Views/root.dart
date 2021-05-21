import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/screen_transition.dart';
import 'package:synthiapp/Controllers/root.dart';
import 'package:synthiapp/Views/Screens/creation_meeting.dart';
import 'package:synthiapp/Widgets/nav_item.dart';
import 'package:synthiapp/config/config.dart';

class Root extends StatefulWidget {
  Root() : super();

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final RootController _controller = RootController();
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: _controller.model.pages[selectedPage]['page'],
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () => utils.pushScreenTransition(context, CreationMeetingPage(), Transitions.UP_TO_DOWN),
        backgroundColor: Theme.of(context).accentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<dynamic> _buildNavItems() {
    List<dynamic> items = [];

    _controller.model.pages.asMap().forEach((index, page) {
      if (page.isEmpty) {
        items.add(
          SizedBox(width: 48),
        );
      } else {
        items.add(NavItem(
          title: page['title'],
          icon: selectedPage == index ? page['selected_icon'] : page['icon'],
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

  _buildBottomNavigationBar() {
    List<dynamic> items = _buildNavItems();

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          items.length,
          (index) => items[index],
        ),
      ),
    );
  }
}