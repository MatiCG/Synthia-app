import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/screen_transition.dart';
import 'package:synthiapp/Models/screens/settings.dart';
import 'package:synthiapp/config/config.dart';

class ListSettingsItem extends StatelessWidget {
  final SettingsItem item;

  const ListSettingsItem({
    required this.item,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => item.screen != null
          ? utils.pushScreenTransition(
              context, item.screen!, Transitions.rightToLeft)
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                color: Color(0xff969696),
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => item.screen != null
                  ? utils.pushScreenTransition(
                      context, item.screen!, Transitions.rightToLeft)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
