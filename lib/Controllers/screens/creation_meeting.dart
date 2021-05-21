import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Models/screens/creation_meeting.dart';
import 'package:synthiapp/Widgets/meeting_add_member.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class CreateMeetingController {
  CreationMeetingModel model = CreationMeetingModel();

  submit(BuildContext context) async {
    if (model.formKey.currentState!.validate()) {
      var ref = await FirebaseFirestore.instance.collection('meetings').add({
        'title': getValueById(FieldsID.MEETING_TITLE),
        'description': getValueById(FieldsID.MEETING_DESCRIPTION),
        'order': getValueById(FieldsID.MEETING_ORDER),
        'note': getValueById(FieldsID.MEETING_NOTES),
        'members': [model.members[0]],
        'schedule': model.fields
            .firstWhere((element) => element is MeetingAddMembersItem)
            .time,
        'reportUrl': '',
        // Fields for IA purpose
        'keywords': '',
        'resume': '',
      });

      await Future.wait(model.members.map((e) async {
        var index = model.members.indexOf(e);
        if (index >= 1) {
          await FirebaseFirestore.instance.collection('invitations').add({
            'user': model.members[index],
            'master': model.members[0],
            'meeting': ref,
            'timestamp': Timestamp.now(),
          });
        }
      }));

      Navigator.pop(context);
    } else {}
  }

  String getValueById(FieldsID id) {
    return (model.fields
            .where((element) =>
                element is SynthiaTextFieldItem && element.id == id)
            .first as SynthiaTextFieldItem)
        .controller
        .text;
  }
}
