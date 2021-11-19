import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class MeetingTitle extends StatelessWidget {
  final Meeting edit;
  final GlobalKey<FormState> form;

  const MeetingTitle({required this.edit, required this.form});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: SynthiaTextField(
        padding: const EdgeInsets.only(left: 16, right: 16),
        field: SynthiaTextFieldItem(
          title: 'Nom de la réunion',
          textController: TextEditingController(text: edit.title),
          onChange: (text) {
            edit.title = text;
          },
        ),
      ),
    );
  }
}
