import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/right.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';
import 'package:synthiapp/config/config.dart';

class SettingsNotificationItem {
  final String title;
  final String subtitle;
  final RightID id;
  final Function(RightID id, bool newValue) onValueChange;
  bool value = false;

  SettingsNotificationItem({
    required this.title,
    required this.id,
    required this.subtitle,
    required this.onValueChange,
  }) {
    value = user.hasRight(id);
  }

  set switchValue(bool newValue) => value = newValue;
  bool get switchValue => value;
}

class SettingsNotificationsModel {
  final State<StatefulWidget> parent;
  final BuildContext context;
  List<ScrollSection> sections = [];
  List<String> notificationsStatus = [];
  final Function({required RightID id, required bool value}) callback;

  SettingsNotificationsModel(this.parent, this.callback, this.context) {
    sections.add(_globalNotifications());
    sections.add(_meetingsNotifications());
  }

  ScrollSection _meetingsNotifications() {
    return ScrollSection(title: 'Notifications de réunions', items: [
      SettingsNotificationItem(
        title: 'Invitation',
        subtitle:
            'Vous receverez une notification dès que vous serez inviter à rejoindre une réunion.',
        id: RightID.meetingInvitation,
        onValueChange: (id, value) => callback(id: id, value: value),
      ),
      SettingsNotificationItem(
        title: 'Jour J',
        subtitle: 'Vous receverez une notification dès qu’une réunion a lieu.',
        id: RightID.meetingRemember,
        onValueChange: (id, value) => callback(id: id, value: value),
      ),
      SettingsNotificationItem(
        title: 'Mis à jour',
        subtitle:
            'Vous receverez une notification dès qu’une réunion est modifiée.',
        id: RightID.meetingUpdated,
        onValueChange: (id, value) => callback(id: id, value: value),
      ),
    ]);
  }

  ScrollSection _globalNotifications() {
    return ScrollSection(title: 'Notifications', items: [
      SettingsNotificationItem(
        title: 'Aucune notifications',
        subtitle: 'Suspendre les notifications jusqu’à leur ré-activation',
        id: RightID.anyNotifications,
        onValueChange: (id, value) => callback(id: id, value: value),
      ),
    ]);
  }
}
