import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/screen_transition.dart';
import 'package:synthiapp/Models/screens/settings.dart';
import 'package:synthiapp/config/config.dart';

class ListSettingsItem extends StatelessWidget {
  final SettingsItem item;

  ListSettingsItem({
    required this.item,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.title,
              style: TextStyle(
                color: Color(0XFF969696),
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () => item.screen != null
                  ? utils.pushScreenTransition(context, item.screen!, Transitions.RIGHT_TO_LEFT)//utils.pushScreen(context, item.screen!)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
