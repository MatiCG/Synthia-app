import 'package:flutter/material.dart';

class SynthiaButton extends StatelessWidget {
  const SynthiaButton({
    Key key,
    @required this.text,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.icon,
    this.iconColor = Colors.white,
    this.action,
    this.alignment = Alignment.bottomCenter,
  }) : super(key: key);

  final Color backgroundColor;
  final String text;
  final Color textColor;
  final IconData icon;
  final Color iconColor;
  final Alignment alignment;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Card(
        elevation: 5,
        color: backgroundColor,
        margin: const EdgeInsets.fromLTRB(64.0, 32.0, 64.0, 32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: icon == null ? null : Icon(icon, color: iconColor),
          title: Text(
            text,
            style: TextStyle(color: textColor)
          ),
          onTap: action,
        ),
      ),
    );
  }
}