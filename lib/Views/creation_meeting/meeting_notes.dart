import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class MeetingNotes extends StatefulWidget {
  final Meeting edit;

  const MeetingNotes({required this.edit}) : super();

  @override
  _MeetingOrderState createState() => _MeetingOrderState();
}

class _MeetingOrderState extends State<MeetingNotes> {
  @override
  Widget build(BuildContext context) {
    return SynthiaTextField(
      padding: const EdgeInsets.only(left: 16, right: 16),
      field: SynthiaTextFieldItem(
        title: 'Notes',
        textController: TextEditingController(text: widget.edit.notes),
        onChange: (text) {
          widget.edit.notes = text;
        },
      ),
    );
  }
}
