import 'package:flutter/material.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class RegisterModel {
  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Form Fields
  List<SynthiaTextFieldItem> fields = [
    SynthiaTextFieldItem(
      id: FieldsID.FIRSTNAME,
      title: 'Prénom',
      hint: 'Prénom',
    ),
    SynthiaTextFieldItem(
      id: FieldsID.LASTNAME,
      title: 'Nom',
      hint: 'Nom',
    ),
    SynthiaTextFieldItem(
      id: FieldsID.EMAIL,
      type: types.EMAIL,
      title: 'E-mail',
      hint: 'Adresse e-mail',
    ),
    SynthiaTextFieldItem(
      id: FieldsID.PASSWORD,
      type: types.PASSWORD,
      title: 'Mot de passe',
      hint: '8 caractères minimum',
    ),
  ];
}
