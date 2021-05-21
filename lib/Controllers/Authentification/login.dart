import 'package:flutter/material.dart';
import 'package:synthiapp/Models/Authentification/login.dart';
import 'package:synthiapp/config/config.dart';

class LoginController {
  LoginModel _model = LoginModel();

  submit() {
    if (_model.formKey.currentState!.validate()) {
      user.signIn(
        email: _model.fields[0].controller.text,
        password: _model.fields[1].controller.text,
      );
    }
  }

  GlobalKey<FormState> get formKey => _model.formKey;

  List get data => _model.fields;
}
