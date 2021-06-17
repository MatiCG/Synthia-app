import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/right.dart';
import 'package:synthiapp/Models/settings/notifications.dart';
import 'package:synthiapp/Widgets/provider.dart';

class SettingsNotificationController {
  final State<StatefulWidget> parent;
  final BuildContext context;
  SettingsNotificationsModel? model;

  SettingsNotificationController(this.parent, this.context) {
    model = SettingsNotificationsModel(parent, callback, context);
  }

  void callback({required RightID id, required bool value}) {
    final state = Provider.of(context);

    // ignore: invalid_use_of_protected_member
    parent.setState(() {
      if (value) {
        state.addUserRight(id);
      } else {
        state.removeUserRight(id);
      }
    });
  }
}
