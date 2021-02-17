import 'package:flutter/material.dart';
import 'package:synthiaapp/Views/account.dart';
import 'package:synthiaapp/Views/home.dart';
import 'package:synthiaapp/Views/settings.dart';

class RootModel {
  int pageIndex = 0;
  List<Widget> _pages = [
    HomePage(),
    AccountPage(),
    SettingsPage(),
  ];

  /// Return the pages
  List<Widget> getPages() {
    return this._pages;
  }
}
