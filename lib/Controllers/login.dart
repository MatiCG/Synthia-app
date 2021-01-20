import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:synthiaapp/Classes/auth.dart';
import 'package:synthiaapp/Models/login.dart';

class LoginController {
  final LoginModel _model = LoginModel();

  void changeFormType() {
    String formType = this.getFormType();

    _model.setFormType(formType == 'login' ? 'register' : 'login');
  }

  /// Authentificate the user. Detecting automatically if
  /// the form is in login or register mode
  Future<void> submitAuthentification(
      GlobalKey<FormState> key, VoidCallback authStatusController) async {
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      if (getFormType() == 'login') {
        _model.setAuthErrorMsg(await _login(authStatusController));
      } else {
        _model.setAuthErrorMsg(await _register(authStatusController));
      }
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
    var result =
        await Auth().createUser(this.getUserEmail(), this.getUserPassword());
    if (result is PlatformException) {
      return result.message;
    } else {
      print('The user has been created successfully');
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
