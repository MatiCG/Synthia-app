enum FormType { login, register }

class LoginModel {
  String _userEmail;
  String _userPassword;
  String _authErrorMsg;
  FormType _formType;

  LoginModel() {
    _formType = FormType.login;
    _userEmail = '';
    _userPassword = '';
    _authErrorMsg = '';
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

  /// Set the auth error message
  void setAuthErrorMsg(String error) {
    this._authErrorMsg = error;
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

  /// Get the auth error message
  String getAuthErrorMsg() {
    return this._authErrorMsg;
  }
}
