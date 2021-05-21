import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/right.dart';
import 'package:synthiapp/Models/settings/report.dart';
import 'package:synthiapp/config/config.dart';

class SettingsReportController {
  final State<StatefulWidget> parent;
  SettingsReportModel? model;

  SettingsReportController(this.parent) {
    model = SettingsReportModel(parent, callback);
  }

  callback(id, value) {
    // ignore: invalid_use_of_protected_member
    parent.setState(() {
      if (value)
        user.addNewRight((id as RightID).asString, upload: true);
      else
        user.removeRight((id as RightID).asString, upload: true);
    });
  }
}
