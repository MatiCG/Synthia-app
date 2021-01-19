import 'package:flutter/material.dart';
import 'package:synthiaapp/Models/root.dart';

class RootController {
  final RootModel _model = RootModel();

  /// Update the PageIndex of the navigationBar
  void updatePageIndex(int value) {
    _model.setPageIndex(value);
  }

  /// Return the list of the Widgets
  /// That are put in the body
  List<Widget> getPages() {
    return _model.getPages();
  }

  /// Return the current index of the
  /// Navigation bar
  int getPageIndex() {
    return _model.getPageIndex();
  }
}
