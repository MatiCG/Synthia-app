import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  Firestore firestore = Firestore.instance;
  Map<String, dynamic> _data;
  String _uid;

  Future<bool> init() async {
    return FirebaseAuth.instance.currentUser().then((value) async {
      _uid = value.uid;
      return firestore.document('users/' + _uid).get().then((value) {
        _data = value.data;
        return true;
      });
    });
  }

  // Remove
  Future<bool> deleteUserAccount() async {
    await firestore.document('users/' + _uid).delete();
    await FirebaseAuth.instance.currentUser().then((value) {
      value.delete();
    });
    await FirebaseAuth.instance.signOut();
    return true;
  }

  // Setters
  void setReportExtension(bool value) {
    firestore
        .document('users/' + _uid)
        .updateData({'report_extension': value == true ? 'pdf' : 'txt'});
  }

  void setReportEmail(bool value) {
    firestore.document('users/' + _uid).updateData({'report_email': value});
  }

  void setMeetingNew(bool value) {
    firestore.document('users/' + _uid).updateData({'meeting_new': value});
  }

  void setMeetingSchedule(bool value) {
    firestore.document('users/' + _uid).updateData({'meeting_time': value});
  }

  void setMeetingChange(bool value) {
    firestore.document('users/' + _uid).updateData({'meeting_update': value});
  }

  void setFullName(String newValue) {
    firestore.document('users/' + _uid).updateData({'fullname': newValue});
  }

  void setEmail(String newValue) {
    firestore.document('users/' + _uid).updateData({'email': newValue});
  }

  void setCompany(String newValue) {
    firestore.document('users/' + _uid).updateData({'company': newValue});
  }

  void setJob(String newValue) {
    firestore.document('users/' + _uid).updateData({'job': newValue});
  }

  void setPhoneNumber(String newValue) {
    firestore.document('users/' + _uid).updateData({'phonenumber': newValue});
  }

  void setUsername(String newValue) {
    firestore.document('users/' + _uid).updateData({'username': newValue});
  }

  // Getters
  String getUid() {
    return _uid;
  }

  bool getReportExtension() {
    final value = _data['report_extension'];
    return value == 'pdf' ? true : false;
  }

  bool getReportEmail() {
    return _data['report_email'];
  }

  bool getMeetingNew() {
    return _data['meeting_new'];
  }

  bool getMeetingSchedule() {
    return _data['meeting_time'];
  }

  bool getMeetingChange() {
    return _data['meeting_update'];
  }

  String getFullName() {
    return _data['firstname'] + ' ' + _data['lastname'];
  }

  String getEmail() {
    return _data['email'];
  }

  String getCompany() {
    return _data['company'];
  }

  String getJob() {
    return _data['job'];
  }

  String getPhoneNumber() {
    return _data['phonenumber'];
  }

  String getUsername() {
    return _data['username'];
  }
}
