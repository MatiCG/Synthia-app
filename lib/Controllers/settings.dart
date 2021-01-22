import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiaapp/Classes/auth.dart';
import 'package:synthiaapp/Models/settings.dart';

class SettingsController {
  SettingsModel _model;
  final dynamic parent;
  Firestore firestore = Firestore.instance;

  SettingsController({this.parent}) {
    this._model = SettingsModel(parent: parent);
  }

  /// Get the setting 'meeting join' value
  bool isMeetingJoinSelected() {
    return _model.getMeetingJoin();
  }

  /// Get the setting 'meeting schelue' value
  bool isMeetingScheduleSelected() {
    return _model.getMeetingSchedule();
  }

  /// Get the setting 'meeting update' value
  bool isMeetingUpdateSelected() {
    return _model.getMeetingUpdate();
  }

  /// Get the setting 'report email' value
  bool isReportEmailSelected() {
    return _model.getReportEmail();
  }

  /// Get the setting 'report format' value
  bool isReportFormatSelected() {
    if (_model.getReportFormat() == 'pdf') {
      return true;
    } else {
      return false;
    }
  }

  /// set the setting 'report format' value
  void setReportFormat(bool value) {
    this.parent.setState(() {
      if (value == true) {
        _model.setReportFormat('pdf');
      } else {
        _model.setReportFormat('txt');
      }
    });
  }

  /// Set the setting 'report email' value
  void setReportEmail(bool value) {
    this.parent.setState(() {
      _model.setReportEmail(value);
    });
  }

  /// Set the setting 'meeting join' value
  void setMeetingJoin(bool value) {
    this.parent.setState(() {
      _model.setMeetingJoin(value);
    });
  }

  /// Set the setting 'meeting schedule' value
  void setMeetingSchedule(bool value) {
    this.parent.setState(() {
      _model.setMeetingSchedule(value);
    });
  }

  /// Set the setting 'meeting join' value
  void setMeetingUpdate(bool value) {
    this.parent.setState(() {
      _model.setMeetingUpdate(value);
    });
  }

  /// Delete the account of the current user
  void deleteAccount(VoidCallback authStatusController) async {
    await Auth().getUser().then((value) async {
      await firestore.document('users/' + value.uid).delete();
      value.delete();
    });
    Auth().signOut();
    authStatusController();
  }
}
