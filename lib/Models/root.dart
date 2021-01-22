import 'package:flutter/material.dart';
import 'package:synthiaapp/Views/account.dart';
import 'package:synthiaapp/Views/home.dart';
import 'package:synthiaapp/Views/settings.dart';

class RootModel {
  int _selectedPage = 0;
  List<Widget> _pages;

  RootModel(VoidCallback authStatusController) {
    this._pages = [
      HomePage(),
      AccountPage(authStatusController: authStatusController),
      SettingsPage(authStatusController: authStatusController),
    ];
  }

  /// Return the pages
  List<Widget> getPages() {
    return this._pages;
  }

  /// Return the indexPage
  int getPageIndex() {
    return this._selectedPage;
  }

  /// Set a new indexPage
  void setPageIndex(int value) {
    this._selectedPage = value;
  }
}
