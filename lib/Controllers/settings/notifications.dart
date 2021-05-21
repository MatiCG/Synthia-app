import 'package:flutter/material.dart';
import 'package:synthiapp/Models/settings/notifications.dart';
import 'package:synthiapp/Widgets/provider.dart';

class SettingsNotificationController {
  final State<StatefulWidget> parent;
  final BuildContext context;
  SettingsNotificationsModel? model;

  SettingsNotificationController(this.parent, this.context) {
    model = SettingsNotificationsModel(parent, callback, context);
  }

  callback(id, value) {
    var state = Provider.of(this.context);

    // ignore: invalid_use_of_protected_member
    parent.setState(() {
      if (value)
        state.addUserRight(id);
      else
        state.removeUserRight(id);
    });
  }
}
