import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Widgets/meeting_add_member.dart';
import 'package:synthiapp/Widgets/textfield.dart';
import 'package:synthiapp/config/config.dart';

class CreationMeetingModel {
  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Form Fields
  DateTime meetingTime = DateTime.now();
  List<DocumentReference> members = [];
  List<String> membersEmails = [];
  List<dynamic> fields = [];

  CreationMeetingModel() {
    members.add(
      FirebaseFirestore.instance.collection('users').doc(user.uid),
    );
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
