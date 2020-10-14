import 'package:flutter/material.dart';

class SynthiaButton extends StatelessWidget {
  const SynthiaButton({
    Key key,
    @required this.text,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.leadingIcon,
    this.leadingIconColor = Colors.white,
    this.trailingIcon,
    this.trailingIconColor = Colors.white,
    this.onPressed,
    this.top = 16.0,
    this.bottom = 0.0,
    this.left = 45.0,
    this.right = 45.0,
  }) : super(key: key);

  final Color color;
  final String text;
  final Color textColor;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final Color leadingIconColor;
  final Color trailingIconColor;
  final Function onPressed;
  final double top;
  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: color,
      margin: new EdgeInsets.fromLTRB(left, top, right, bottom),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Icon(leadingIcon,
                color: trailingIcon == null ? leadingIconColor : color),
            Expanded(
                child: Text(text,
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center)),
            Icon(trailingIcon,
                color: leadingIcon == null ? trailingIconColor : color),
          ]),
        ),
      ),
    );
  }
}
