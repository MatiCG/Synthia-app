import 'package:flutter/material.dart';
import 'package:synthiaapp/Views/home.dart';

class RootModel {
  int _selectedPage = 0;
  List<Widget> _pages;

  RootModel() {
    this._pages = [
      HomePage(),
      Text('ok'),
      Text('ok'),
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
