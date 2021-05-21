import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/right.dart';
import 'package:synthiapp/Models/settings/notifications.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';

class SettingsReportModel {
  final State<StatefulWidget> parent;
  final Function(RightID id, bool value) callback;
  List<ScrollSection> sections = [];

  SettingsReportModel(this.parent, this.callback) {
    sections.add(_reportNotifications());
  }

  _reportNotifications() {
    return ScrollSection(title: 'Compte-Rendu', items: [
      SettingsNotificationItem(
        title: 'Envoie par e-mail',
        subtitle:
            'Vous receverez le compte-rendu d’une réunion par e-mail dès que celui-ci est disponible.',
//        parent: parent,
        id: RightID.REPORT_SEND_EMAIL,
        onValueChange: (id, newValue) => callback(id, newValue),
      ),
      SettingsNotificationItem(
        title: 'Format du fichier',
        subtitle:
            'Choisissez le format du fichier. Ce format sera utilisé pour le téléchargement et l’envoie du compte-rendu',
        id: RightID.REPORT_PDF_FILE,
        onValueChange: (id, newValue) => callback(id, newValue),
        //parent: parent,
      ),
    ]);
  }
}
