import 'package:flutter/cupertino.dart';
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
  void submitAuthentification(
      GlobalKey<FormState> key, VoidCallback authStatusController) async {
    final form = key.currentState;
    print(getFormType());
    if (form.validate()) {
      form.save();
      if (getFormType() == 'login') {
        _login(authStatusController);
      } else {
        _register(authStatusController);
      }
    }
  }

  /// Login the user
  void _login(VoidCallback authStatusController) async {
    String userId =
        await Auth().signIn(this.getUserEmail(), this.getUserPassword());
    if (userId != null) {
      print('The user has been signIn successfully');
      authStatusController();
    }
  }

  /// Register the user
  void _register(VoidCallback authStatusController) async {
    String userId =
        await Auth().createUser(this.getUserEmail(), this.getUserPassword());
    if (userId != null) {
      print('The user has been created successfully');
      authStatusController();
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

  // Getters Region

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
