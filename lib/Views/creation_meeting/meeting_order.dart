import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synthiapp/Models/screens/creation_meeting.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class MeetingOrder extends StatefulWidget {
  final Meeting edit;

  const MeetingOrder({required this.edit}) : super();

  @override
  _MeetingOrderState createState() => _MeetingOrderState();
}

class _MeetingOrderState extends State<MeetingOrder> {
  @override
  void initState() {
    super.initState();

    print('DEBUG: ${widget.edit.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    return SynthiaTextField(
      padding: const EdgeInsets.only(left: 16, right: 16),
      onChange: (text) {
        widget.edit.order = text ?? widget.edit.order;
      },
      field: SynthiaTextFieldItem(
          title: 'Ordre du jour',
          textController: TextEditingController(text: widget.edit.order)),
    );
  }
}
