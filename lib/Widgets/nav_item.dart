import 'package:flutter/material.dart';

class NavItem extends StatefulWidget {
  const NavItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super();

  final String title;
  final IconData icon;
  final bool isSelected;
  final Function()? onTap;

  @override
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.isSelected
                  ? Theme.of(context).accentColor
                  : Colors.grey,
            ),
            SizedBox(
              height: 20,
              width: 100,
              child: Align(
                child: AnimatedDefaultTextStyle(
                  curve: Curves.bounceInOut,
                  style: widget.isSelected
                      ? _selectedTextStyle()
                      : _unselectedTextStyle(),
                  duration: const Duration(milliseconds: 100),
                  child: Text(widget.title),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _selectedTextStyle() {
    return TextStyle(
      color: Theme.of(context).accentColor,
      fontSize: 16,
    );
  }

  TextStyle _unselectedTextStyle() {
    return TextStyle(
      color: Colors.grey.shade700,
      fontSize: 12,
    );
  }
}
