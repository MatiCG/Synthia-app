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
    this.value = user.hasRight(this.id.asString);
  }

  set switchValue(bool newValue) =>  value = newValue;
}

class SettingsNotificationsModel {
  final State<StatefulWidget> parent;
  final BuildContext context;
  List<ScrollSection> sections = [];
  List<String> notificationsStatus = [];
  final Function(RightID id, bool value) callback;

  SettingsNotificationsModel(this.parent, this.callback, this.context) {
    sections.add(_globalNotifications());
    sections.add(_meetingsNotifications());
  }

  _meetingsNotifications() {
    return ScrollSection(title: 'Notifications de réunions', items: [
      SettingsNotificationItem(
        title: 'Invitation',
        subtitle:
            'Vous receverez une notification dès que vous serez inviter à rejoindre une réunion.',
        id: RightID.MEETING_INVITATION,
        onValueChange: (id, value) => callback(id, value),
      ),
      SettingsNotificationItem(
        title: 'Jour J',
        subtitle: 'Vous receverez une notification dès qu’une réunion a lieu.',
        id: RightID.MEETING_REMEMBER,
        onValueChange: (id, value) => callback(id, value),
      ),
      SettingsNotificationItem(
        title: 'Mis à jour',
        subtitle:
            'Vous receverez une notification dès qu’une réunion est modifiée.',
        id: RightID.MEETING_UPDATED,
        onValueChange: (id, value) => callback(id, value),
      ),
    ]);
  }

  _globalNotifications() {
    return ScrollSection(title: 'Notifications', items: [
      SettingsNotificationItem(
        title: 'Aucune notifications',
        subtitle: 'Suspendre les notifications jusqu’à leur ré-activation',
        id: RightID.ANY_NOTIFICATIONS,
        onValueChange: (id, value) => callback(id, value),
      ),
    ]);
  }
}
