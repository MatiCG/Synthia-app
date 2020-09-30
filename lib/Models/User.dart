import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  Firestore firestore = Firestore.instance;
  Map<String, dynamic> _data;
  String _uid;

  User(String uid) {
    _uid = uid;
  }

  void setData(Map<String, dynamic> data) {
    _data = data;
  }

  Future<bool> init() async {
    firestore.document('users/' + _uid).get().then((value) {
      _data = value.data;
    });
    var value = await firestore.document('users/' + _uid).get();

    _data = value.data;
    return true;
  }

  // Setters

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
