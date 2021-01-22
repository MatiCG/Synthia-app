import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synthiaapp/Classes/auth.dart';
import 'package:synthiaapp/Models/account.dart';

class AccountController {
  AccountModel _model = AccountModel();
  FirebaseUser _user;
  final dynamic parent;

  AccountController({this.parent}) {
    _model.getUser().then((value) {
      parent.setState(() {
        this._user = value;
      });
    });
  }

  void submitEdit(GlobalKey<FormState> key) async {
    if (this.parent.isEditing && key.currentState.validate()) {
      key.currentState.save();
      this.parent.setState(() {
        this.parent.isEditing = false;
      });
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = _model.getEditUsername();
      await _user.updateProfile(userUpdateInfo);
      _user.reload().then((value) {
        this._model.getUser().then((value) {
          this.parent.setState(() {
            this._user = value;
          });
        });
      });
    }
  }

  /// Logout user from his session
  void logout(VoidCallback authStatusController) {
    Auth().signOut();
    authStatusController();
  }

  /// Get the user FullName
  String getUserUsername() {
    return _user == null || _user.displayName == null ? '' : _user.displayName;
  }

  /// Get the user email
  String getUserEmail() {
    return _user == null ? '' : _user.email;
  }

  /// Get the user profile picture
  String getUserProfilePicture() {
    return _user == null || _user.photoUrl == null ? '' : _user.photoUrl;
  }

  /// Get the user phone number
  String getUserPhoneNumber() {
    return _user == null || _user.phoneNumber == null
        ? 'not specified'
        : _user.phoneNumber;
  }

  /// Set user edit username
  void setUserEditUsername(String value) {
    _model.setEditUsername(value);
  }
}
