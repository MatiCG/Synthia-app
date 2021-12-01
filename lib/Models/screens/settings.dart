import 'package:flutter/material.dart';
import 'package:synthiapp/Views/settings/privacy_policy.dart';
import 'package:synthiapp/Views/settings/report.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';
import 'package:synthiapp/config/config.dart';

class SettingsItem {
  final String title;
  Widget? screen;

  SettingsItem({
    this.title = '',
    this.screen,
  });

  set newScreen(Widget? newScreen) => screen = newScreen;
  Widget? get newScreen => screen;
}

class SettingsModel {
  List<ScrollSection> sections = [];
  String userPicture = user.data?.photoURL ?? 'assets/avatars/avatar_01.png';
  SettingsModel() {
    sections.add(_accountSection());
  }

  ScrollSection _accountSection() {
    return ScrollSection(title: 'Compte', items: [
      /*
      SettingsItem(
          title: 'Paramètres de notifications',
          screen: const SettingsNotifications()),
      */
      SettingsItem(
          title: 'Paramètres de compte rendu', screen: const SettingsReport()),
      SettingsItem(title: 'Confidentialité', screen: const PrivacyPolicy()),
    ]);
  }
}
