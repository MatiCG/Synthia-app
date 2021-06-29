import 'package:flutter/material.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class RegisterModel {
  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Form Fields
  List<SynthiaTextFieldItem> fields = [
    SynthiaTextFieldItem(
      id: FieldsID.firstname,
      title: 'Prénom',
      hint: 'Prénom',
    ),
    SynthiaTextFieldItem(
      id: FieldsID.lastname,
      title: 'Nom',
      hint: 'Nom',
    ),
    SynthiaTextFieldItem(
      id: FieldsID.email,
      type: types.email,
      title: 'E-mail',
      hint: 'Adresse e-mail',
    ),
    SynthiaTextFieldItem(
      id: FieldsID.password,
      type: types.password,
      title: 'Mot de passe',
      hint: '8 caractères minimum',
    ),
  ];
}
