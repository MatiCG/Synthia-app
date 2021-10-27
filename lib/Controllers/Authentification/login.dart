import 'package:flutter/material.dart';
import 'package:synthiapp/Models/Authentification/login.dart';
import 'package:synthiapp/config/config.dart';

class LoginController {
  final State<StatefulWidget> parent;
  final LoginModel _model = LoginModel();

  LoginController(this.parent);

  Future submit() async {
    if (_model.formKey.currentState!.validate()) {
      final String msg = await user.signIn(
        email: _model.fields[0].controller.text,
        password: _model.fields[1].controller.text,
      );

      utils.updateView(parent, update: () {
        if (msg.isNotEmpty) {
          _model.errorMsg = msg;
        }
      });
    }
  }

  GlobalKey<FormState> get formKey => _model.formKey;

  List get data => _model.fields;

  LoginModel get model => _model;
}
