import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:synthiaapp/Classes/auth.dart';
import 'package:synthiaapp/Models/login.dart';

class LoginController {
  final LoginModel _model = LoginModel();
  dynamic _parent;

  LoginController(dynamic parent) {
    this._parent = parent;
  }

  void changeFormType() {
    String formType = this.getFormType();
    _parent.setState(() {
      _model.setFormType(formType == 'login' ? 'register' : 'login');
    });
  }

  /// Authentificate the user. Detecting automatically if
  /// the form is in login or register mode
  Future<void> submitAuthentification(
      GlobalKey<FormState> key, VoidCallback authStatusController) async {
    final form = key.currentState;
    String messageError;

    if (form.validate()) {
      form.save();
      if (getFormType() == 'login') {
        messageError = await _login(authStatusController);
      } else {
        messageError = await _register(authStatusController);
      }
      _parent.setState(() {
        _model.setAuthErrorMsg(messageError);
      });
    }
  }

  /// Login the user
  Future<String> _login(VoidCallback authStatusController) async {
    var result =
        await Auth().signIn(this.getUserEmail(), this.getUserPassword());
    if (result is PlatformException) {
      return result.message;
    } else {
      print('The user has been signIn successfully');
      authStatusController();
      return '';
    }
  }

  /// Register the user
  Future<String> _register(VoidCallback authStatusController) async {
    Firestore firestore = Firestore.instance;
    var result =
        await Auth().createUser(this.getUserEmail(), this.getUserPassword());
    if (result is PlatformException) {
      return result.message;
    } else {
      print('The user has been created successfully');
      FirebaseUser user = await Auth().getUser();
      // Create basic data needed !
      await firestore.document('users/' + user.uid).setData({
        'settings_meeting_joined': false,
        'settings_meeting_scheduled': false,
        'settings_meeting_updated': false,
        'settings_report_email': false,
        'settings_report_format': 'pdf',
      });
      authStatusController();
      return '';
    }
  }

  // Setters Region

  /// Save user email
  void setUserEmail(String email) {
    if (email.isNotEmpty) {
      _model.setUserEmail(email);
    }
  }

  /// Save user password
  void setUserPassword(String password) {
    if (password.isNotEmpty) {
      _model.setUserPassword(password);
    }
  }

  void setAuthErrorMsg(String error) {
    _model.setAuthErrorMsg(error == null ? '' : error);
  }

  // Getters Region

  /// Return the error message when authentification
  /// failed
  String getAuthErrorMsg() {
    return _model.getAuthErrorMsg();
  }

  /// Return the user email
  String getUserEmail() {
    return _model.getUserEmail();
  }

  // Return the user password
  String getUserPassword() {
    return _model.getUserPassword();
  }

  /// Return the form type. Login or Register
  String getFormType() {
    return _model.getFormType();
  }

  /// Return user status. SIGNEDIN or NOTSIGNEDIN
  Future<String> getUserAuthStatus() async {
    return await Auth().currentUser();
  }
}
