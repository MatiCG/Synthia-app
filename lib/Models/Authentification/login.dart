import 'package:flutter/material.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class LoginModel {
  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Form Fields
  List<SynthiaTextFieldItem> fields = [
    SynthiaTextFieldItem(
      type: types.EMAIL,
      title: 'E-mail',
      hint: 'Adresse e-mail',
    ),
    SynthiaTextFieldItem(
      type: types.PASSWORD,
      title: 'Mot de passe',
      hint: '8 caractères minimum',
    ),
  ];
}