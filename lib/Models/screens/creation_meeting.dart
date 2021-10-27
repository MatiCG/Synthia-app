import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/Widgets/meeting_add_member.dart';
import 'package:synthiapp/Widgets/textfield.dart';
import 'package:synthiapp/config/config.dart';

/*
class MeetingCreation {
  String title = '';
  String order = '';
  String notes = '';
  List<dynamic> members = [];
  DateTime date = DateTime.now();
  TimeOfDay startAt = TimeOfDay.now();
  TimeOfDay endAt = TimeOfDay.now();
  DocumentReference? ref;

  MeetingCreation();

  MeetingCreation.from(Meeting meeting) {
    title = meeting.title;
    order = meeting.order;
    notes = meeting.notes;
    members = meeting.members ?? [];
    date = meeting.date ?? DateTime.now();
    startAt = meeting.startAt ?? TimeOfDay.now();
    endAt = meeting.endAt ?? TimeOfDay.now();
    ref = meeting.document;
  }

  Map toJson() => {
        'title': title,
        'order': order,
        'notes': notes,
        'participants': members,
        'date': date,
        'startAt': startAt,
        'endAt': endAt,
      };
}
*/

class CreationMeetingModel {
  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Form Fields
  DateTime meetingTime = DateTime.now();
  List<DocumentReference> members = [];
  List<String> membersEmails = [];
  List<dynamic> fields = [];
  late Meeting meeting;
//  MeetingCreation edit = MeetingCreation();

  CreationMeetingModel(edit, {Meeting? existMeeting}) {
    if (edit == true && existMeeting != null) {
      meeting = existMeeting;
    } else {
      meeting = Meeting.create();
      meeting.members.add(
        FirebaseFirestore.instance.collection('users').doc(user.uid),
      );
    }
    fields = [
      SynthiaTextFieldItem(
          id: FieldsID.meetingTitle, title: 'Nom de la réunion'),
      MeetingAddMembersItem(members: members, time: meetingTime),
      SynthiaTextFieldItem(id: FieldsID.meetingOrder, title: 'Ordre du jour'),
      SynthiaTextFieldItem(
          id: FieldsID.meetingDescription, title: 'Description'),
      SynthiaTextFieldItem(id: FieldsID.meetingNotes, title: 'Notes'),
    ];
  }
}
