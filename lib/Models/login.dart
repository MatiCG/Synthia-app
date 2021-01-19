enum FormType { login, register }

class LoginModel {
  String _userEmail;
  String _userPassword;
  FormType _formType;

  LoginModel() {
    _formType = FormType.login;
    _userEmail = '';
    _userPassword = '';
  }

  /// Set the user email
  void setUserEmail(String email) {
    this._userEmail = email;
  }

  /// Set the user password
  void setUserPassword(String password) {
    this._userPassword = password;
  }

  /// Set the state of the form. Login or Register
  void setFormType(String type) {
    _formType = type == 'login' ? FormType.login : FormType.register;
  }

  /// Get the current state of the form. Login or Register
  String getFormType() {
    return _formType == FormType.login ? 'login' : 'register';
  }

  /// Get the user email
  String getUserEmail() {
    return this._userEmail;
  }

  /// Get the user password
  String getUserPassword() {
    return this._userPassword;
  }
}
