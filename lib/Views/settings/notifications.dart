import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/settings/notifications.dart';
import 'package:synthiapp/Widgets/app_bar.dart';
import 'package:synthiapp/Widgets/list_settings_notification_item.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';

class SettingsNotifications extends StatefulWidget {
  SettingsNotifications() : super();

  @override
  _SettingsNotificationsState createState() => _SettingsNotificationsState();
}

class _SettingsNotificationsState extends State<SettingsNotifications> {
  SettingsNotificationController? _controller;

  @override
  void initState() {
    super.initState();

    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {
          _controller = SettingsNotificationController(this, context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _controller!.model == null) return Scaffold();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: SynthiaAppBar(
        title: 'Paramètres de notifications',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 4.0),
          child: SynthiaScrollList(
            sections: _controller!.model!.sections,
            headerBuilder: (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                child: Text(
                  _controller!.model!.sections[index].title,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
            itemBuilder: (headerIndex, index) {
              return ListSettingsNotificationItem(
                item: _controller!.model!.sections[headerIndex].items[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
