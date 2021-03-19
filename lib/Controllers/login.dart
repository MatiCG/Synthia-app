import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:synthiaapp/Models/login.dart';
import 'package:synthiaapp/config.dart';

class LoginController {
  final LoginModel model = LoginModel();
  dynamic _parent;

  LoginController(dynamic parent) {
    this._parent = parent;
  }

  void changeFormType() {
    FormType formType = model.formType;

    // Before doing the setState check if the widget is mounted to avoid errors
    if (!_parent.mounted) return;

    // Notify the parent (The view) that the form type has change.
    _parent.setState(() {
      model.form =
          formType == FormType.login ? FormType.register : FormType.login;
    });
  }

  /// Authentificate the user. Detecting automatically if
  /// the form is in login or register mode
  Future<void> submitAuthentification(GlobalKey<FormState> key) async {
    final form = key.currentState;
    String messageError;

    if (form.validate()) {
      form.save();
      if (model.formType == FormType.login) {
        messageError = await _login();
      } else {
        messageError = await _register();
      }

      // Before doing the setState check if the widget is mounted to avoid errors
      if (!_parent.mounted) return;

      // Notify the parent (The view) that the message error has change.
      _parent.setState(() {
        model.authError = messageError;
      });
    }
  }

  /// Login the user
  Future<String> _login() async {
    dynamic result = await auth.signIn(model.userEmail, model.userPassword);

    if (result is FirebaseAuthException) {
      return result.message;
    } else {
      print('The user has been signIn successfully');
      return '';
    }
  }

  /// Register the user
  Future<String> _register() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    dynamic result = await auth.createUser(model.userEmail, model.userPassword);

    if (result is FirebaseAuthException) {
      return result.message;
    } else {
      print('The user has been created successfully');
      // Initiate the basics data needed in the database about the user settings
      try {
        await firestore.doc('users/' + auth.user.uid).set({
          'settings_meeting_joined': false,
          'settings_meeting_scheduled': false,
          'settings_meeting_updated': false,
          'settings_report_email': false,
          'settings_report_format': 'pdf',
        });
      } catch (error) {
        print(
            'An error occured when trying to set data in the database.\n$error');
      }
      return '';
    }
  }
}
