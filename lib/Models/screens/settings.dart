import 'package:flutter/material.dart';
import 'package:synthiapp/Views/settings/notifications.dart';
import 'package:synthiapp/Views/settings/privacy_policy.dart';
import 'package:synthiapp/Views/settings/report.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';
import 'package:synthiapp/config/config.dart';

class SettingsItem {
  final String title;
  Widget? screen;

  SettingsItem({
    required this.title,
    this.screen,
  });

  set newScreen(Widget newScreen) => screen = newScreen;
}

class SettingsModel {
  List<ScrollSection> sections = [];
  String userPicture = user.data?.photoURL ?? 'assets/avatars/avatar_01.png';

  SettingsModel() {
    sections.add(_accountSection());
    sections.add(_securitySection());
  }

  ScrollSection _accountSection() {
    return ScrollSection(title: 'Compte', items: [
      SettingsItem(
          title: 'Paramètres de notifications',
          screen: SettingsNotifications()),
      SettingsItem(
          title: 'Paramètres de compte rendu', screen: SettingsReport()),
      SettingsItem(title: 'Confidentialité', screen: PrivacyPolicy()),
    ]);
  }

  ScrollSection _securitySection() {
    return ScrollSection(title: 'Sécurité', items: [
      SettingsItem(title: 'PIN/Biometrics requis'),
    ]);
  }
}
