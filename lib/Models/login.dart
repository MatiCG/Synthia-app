enum FormType { login, register }

class LoginModel {
  String userEmail = '';
  String userPassword = '';
  String authErrorMsg = '';
  FormType formType = FormType.login;

  // Setters

  /// Set the user email
  set email(String email) => userEmail = email;

  /// Set the user password
  set password(String password) => userPassword = password;

  /// Set the state of the form. login or register
  set form(FormType form) => formType = form;

  /// Set the authentification error message to help the user to understand
  /// what happened !
  set authError(String message) => authErrorMsg = message;
}
