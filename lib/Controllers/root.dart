import 'package:flutter/material.dart';
import 'package:synthiaapp/Models/root.dart';

class RootController {
  RootModel model = RootModel();

  /// Update the PageIndex of the navigationBar
  set pageIndex(int value) => model.pageIndex;

  /// Return the list of the Widgets
  /// That are put in the body
  List<Widget> getPages() {
    return model.getPages();
  }
}
