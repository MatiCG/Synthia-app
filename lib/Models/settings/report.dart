import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/right.dart';
import 'package:synthiapp/Models/settings/notifications.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';

class SettingsReportModel {
  final State<StatefulWidget> parent;
  final Function({required RightID id, required bool value}) callback;
  List<ScrollSection> sections = [];

  SettingsReportModel(this.parent, this.callback) {
    sections.add(_reportNotifications());
  }

  ScrollSection _reportNotifications() {
    return ScrollSection(title: 'Compte-Rendu', items: [
      SettingsNotificationItem(
        title: 'Envoie par e-mail',
        subtitle:
            'Vous receverez le compte-rendu d’une réunion par e-mail dès que celui-ci est disponible.',
//        parent: parent,
        id: RightID.reportSendEmail,
        onValueChange: (id, newValue) => callback(id: id, value: newValue),
      ),
    ]);
  }
}
