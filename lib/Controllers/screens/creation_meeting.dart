import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Models/screens/creation_meeting.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Views/creation_meeting/meeting_members.dart';
import 'package:synthiapp/Views/creation_meeting/meeting_notes.dart';
import 'package:synthiapp/Views/creation_meeting/meeting_order.dart';
import 'package:synthiapp/Views/creation_meeting/meeting_time.dart';
import 'package:synthiapp/Views/creation_meeting/meeting_title.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class CreateMeetingController {
  late CreationMeetingModel model;
  List<Widget> items = [];

  CreateMeetingController(edit, {Meeting? existMeeting}) {
    model = CreationMeetingModel(edit, existMeeting: existMeeting);
    items
      ..add(MeetingTitle(edit: model.meeting, form: model.formKey))
      ..add(MeetingTime(model.meeting))
      ..add(MeetingMembers(edit: model.meeting))
      ..add(MeetingOrder(edit: model.meeting))
      ..add(MeetingNotes(edit: model.meeting));
  }

  Future submitEdit(BuildContext context) async {
    if (model.meeting.document == null) return;
    final timeStart = DateTime(
        1999, 1, 1, model.meeting.startAt!.hour, model.meeting.startAt!.minute);
    final timeEnd = DateTime(
        1999, 1, 1, model.meeting.endAt!.hour, model.meeting.endAt!.minute);

    FirebaseFirestore.instance
        .collection('meetings')
        .doc(model.meeting.document!.id)
        .update({
      'title': model.meeting.title,
      'order': model.meeting.order,
      'note': model.meeting.notes,
      'members': model.meeting.members,
      'date': Timestamp.fromDate(model.meeting.date!),
      'startAt': Timestamp.fromDate(timeStart),
      'endAt': Timestamp.fromDate(timeEnd),
    }).then((value) {
      Navigator.pop(context, model.meeting);
    });
  }

  Future submit(BuildContext context) async {
    if (model.formKey.currentState!.validate()) {
      final timeStart = DateTime(1999, 1, 1, model.meeting.startAt!.hour,
          model.meeting.startAt!.minute);
      final timeEnd = DateTime(
          1999, 1, 1, model.meeting.endAt!.hour, model.meeting.endAt!.minute);

      final ref = await FirebaseFirestore.instance.collection('meetings').add({
        'title': model.meeting.title,
        'order': model.meeting.order,
        'note': model.meeting.notes,
        'members': [model.meeting.members[0]],
        'date': Timestamp.fromDate(model.meeting.date!),
        'startAt': Timestamp.fromDate(timeStart),
        'endAt': Timestamp.fromDate(timeEnd),
        // All fields necessary for another things
        'reportUrl': '',
        'keywords': '',
        'resume': '',
      });

      await Future.wait(model.meeting.members.map((e) async {
        final index = model.meeting.members.indexOf(e);
        if (index >= 1) {
          await FirebaseFirestore.instance.collection('invitations').add({
            'user': model.meeting.members[index],
            'master': model.meeting.members[0],
            'meeting': ref,
            'timestamp': Timestamp.now(),
          });
        }
      }));
      Navigator.pop(context);
    }
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
