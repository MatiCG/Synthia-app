import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synthiaapp/config.dart';

class SettingsModel {
  final dynamic parent;
  Map<String, dynamic> data = Map<String, dynamic>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User user;
  bool isJoinSelected;
  bool isScheduleSelected;
  bool isUpdateSelected;
  bool isMailingReportSelected;
  bool isFormatReportSelected;

  SettingsModel({this.parent}) {
    user = auth.user;
    firestore.doc('users/' + user?.uid).get().then((value) {
      parent.setState(() {
        isJoinSelected = value['settings_meeting_joined'];
        isScheduleSelected = value['settings_meeting_scheduled'];
        isUpdateSelected = value['settings_meeting_updated'];
        isMailingReportSelected = value['settings_report_email'];
        isFormatReportSelected =
          value['settings_report_format'] == 'pdf' ? true : false;
      });
    });
  }

  void updateData() {
    DocumentReference documentReference =
        firestore.doc('users/' + user.uid);

    documentReference.update({
      'settings_meeting_joined': isJoinSelected,
      'settings_meeting_scheduled': isScheduleSelected,
      'settings_meeting_updated': isUpdateSelected,
      'settings_report_email': isMailingReportSelected,
      'settings_report_format': isFormatReportSelected ? 'pdf' : 'txt',
    });
  }

  set setJoinSelected(bool value) {
    parent.setState(() {
      isJoinSelected = value;
      updateData();
    });
  }

  set setUpdateSelected(bool value) {
    parent.setState(() {
      isUpdateSelected = value;
      updateData();
    });
  }

  set setScheduleSelected(bool value) {
    parent.setState(() {
      isScheduleSelected = value;
      updateData();
    });
  }

  set setMailingReportSelected(bool value) {
    parent.setState(() {
      isMailingReportSelected = value;
      updateData();
    });
  }

  set setFormatReportSelected(bool value) {
    parent.setState(() {
      isFormatReportSelected = value;
      updateData();
    });
  }
}
