import 'package:flutter/material.dart';

class SynthiaAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;

  final String title;
  final dynamic returnValue;
  final IconData closeIcon;

  const SynthiaAppBar({
    required this.title,
    this.returnValue,
    this.closeIcon = Icons.chevron_left,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        Container(
          width: 50,
        ),
      ],
      leading: SizedBox(
        width: 50,
        child: IconButton(
          icon: Icon(closeIcon),
          onPressed: () => Navigator.pop(context, returnValue),
        ),
      ),
      title: SizedBox(
        width: double.infinity,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
