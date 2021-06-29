import 'package:flutter/material.dart';
import 'package:synthiapp/Models/settings/notifications.dart';

class ListSettingsNotificationItem extends StatefulWidget {
  final SettingsNotificationItem item;

  const ListSettingsNotificationItem({
    required this.item,
  }) : super();

  @override
  _ListSettingsNotificationItemState createState() =>
      _ListSettingsNotificationItemState();
}

class _ListSettingsNotificationItemState
    extends State<ListSettingsNotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.item.subtitle,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    color: Color(0xff969696),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.item.value,
            onChanged: (value) {
              widget.item.onValueChange(widget.item.id, value);
              widget.item.switchValue = value;
            },
          ),
        ],
      ),
    );
  }
}
