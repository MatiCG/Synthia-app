import 'package:flutter/material.dart';

class SynthiaButton extends StatelessWidget {
  SynthiaButton({
    required this.text,
    required this.onPressed,
    this.textOnly = false,
    this.margin = const EdgeInsets.all(8.0),
    this.color,
    this.textColor,
    this.disableColor = Colors.grey,
    this.enable = true,
  }) : super();

  final String? text;
  final bool textOnly;
  final Function onPressed;
  final EdgeInsets margin;
  final Color? color;
  final Color? textColor;
  final Color disableColor;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    Color buttonColor = color == null ? Theme.of(context).primaryColor : color!;
    Color txtColor =
        textColor == null ? Theme.of(context).accentColor : textColor!;

    buttonColor = textOnly ? Colors.transparent : buttonColor;
    buttonColor = enable ? buttonColor : disableColor;

    return Card(
      elevation: textOnly ? 0 : 5,
      margin: margin,
      color: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () => enable ? onPressed() : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: screenWidth * 0.8,
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.030,
            ),
            child: Center(
              child: Text(
                text!,
                style: TextStyle(
                  color: txtColor,
                  fontSize: screenHeight * 0.025,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
