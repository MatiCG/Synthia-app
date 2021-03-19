import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synthiaapp/Models/account.dart';
import 'package:synthiaapp/config.dart';

class AccountController {
  AccountModel model = AccountModel();
  User user;
  final dynamic parent;

  AccountController({this.parent}) {
    parent.setState(() {
      user = auth.user;
      model.username =
          user.displayName == null ? '[No username]' : user.displayName;
    });
  }

  /// Edit the data in the form fields a,d save them in the
  /// user database
  void submitEdit(GlobalKey<FormState> key) async {
    FormState form = key.currentState;

    if (parent.isEditing && form.validate()) {
      form.save();
      parent.setState(() {
        parent.isEditing = false;
      });
      await auth.user.updateProfile(displayName: model.username);
      await auth.user.reload();
      //    userData.displayName = model.username;
      //  await user.updateProfile(userData);
    }
  }

  /// Logout user from his session and go back to login screen
  void logout() {
    auth.signOut();
  }
}
