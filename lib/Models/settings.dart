import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synthiaapp/Classes/auth.dart';

class SettingsModel {
  Firestore firestore = Firestore.instance;
  bool _joinMeeting;
  bool _scheduleMeeting;
  bool _updatedMeeting;
  bool _emailReport;
  String _formatReport;
  FirebaseUser _user;
  Map<String, dynamic> _data = Map<String, dynamic>();
  final dynamic parent;

  SettingsModel({this.parent}) {
    Auth().getUser().then((value) {
      _user = value;
      firestore.document('users/' + _user.uid).get().then((value) {
        this.parent.setState(() {
          _joinMeeting = value['settings_meeting_joined'];
          _scheduleMeeting = value['settings_meeting_scheduled'];
          _updatedMeeting = value['settings_meeting_updated'];
          _emailReport = value['settings_report_email'];
          _formatReport = value['settings_report_format'];
        });
      });
    });
  }

  /// Set the meeting join field
  void setMeetingJoin(bool value) {
    _joinMeeting = value;
    firestore
        .document('users/' + _user.uid)
        .updateData({'settings_meeting_joined': value});
  }

  /// Set the meeting schedule field
  void setMeetingSchedule(bool value) {
    _scheduleMeeting = value;
    firestore
        .document('users/' + _user.uid)
        .updateData({'settings_meeting_scheduled': value});
  }

  /// Set the meeting update field
  void setMeetingUpdate(bool value) {
    _updatedMeeting = value;
    firestore
        .document('users/' + _user.uid)
        .updateData({'settings_meeting_updated': value});
  }

  /// Set the report email field
  void setReportEmail(bool value) {
    _emailReport = value;
    firestore.document('users/' + _user.uid).updateData({
      'settings_report_email': value,
    });
  }

  /// Set the report format field
  void setReportFormat(String value) {
    _formatReport = value;
    firestore.document('users/' + _user.uid).updateData({
      'settings_report_format': value,
    });
  }

  /// Return the value of the report format field
  String getReportFormat() {
    return _formatReport;
  }

  /// Return the bool of the report email field
  bool getReportEmail() {
    return _emailReport;
  }

  /// Return the bool of the meeting join field
  bool getMeetingJoin() {
    return _joinMeeting;
  }

  /// Return the bool of the meeting schedule field
  bool getMeetingSchedule() {
    return _scheduleMeeting;
  }

  /// Return the bool of the meeting updated field
  bool getMeetingUpdate() {
    return _updatedMeeting;
  }
}
