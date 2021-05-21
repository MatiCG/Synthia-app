import 'package:flutter/material.dart';
import 'package:synthiapp/Views/Screens/home.dart';
import 'package:synthiapp/Views/Screens/settings.dart';

class RootModel {
  final List<Map<String, dynamic>> pages = [
    {
      'title': 'Accueil',
      'icon': Icons.home_outlined,
      'selected_icon': Icons.home,
      'page': HomePage(),
    },
    {
      // An item not instanciate will be considerate has a sizebox
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_outlined,
      'selected_icon': Icons.settings,
      'page': SettingsPage(),
    }
  ];
}
