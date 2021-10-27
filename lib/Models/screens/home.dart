import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
/*
  String title;
  String resume;
  String order;
  String notes;
  List members;
  Timestamp? date;
  Timestamp? startAt;
  Timestamp? endAt;
  DocumentReference document;
  String master;
  */

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
class Meeting {
  late String title;
  late String order;
  late String notes;
  late String resumee;
  late List<dynamic> members;
  DateTime? date;
  TimeOfDay? startAt;
  TimeOfDay? endAt;
  late DocumentReference? document;
  late String master;

  Meeting({
    this.title = '',
    this.order = '',
    this.notes = '',
    this.resumee = '',
    this.members = const [],
    this.date,
    this.startAt,
    this.endAt,
    this.document,
    this.master = '',
  });

  Meeting.create() {
    title = '';
    order = '';
    notes = '';
    resumee = '';
    members = [];
    master = '';
    document = null;
    date = DateTime.now();
    startAt = TimeOfDay.now();
    endAt = TimeOfDay.now();
  }

  Map toJson() => {
        'title': title,
        'order': order,
        'notes': notes,
        'resume': resumee,
        'members': members,
        'date': date,
        'startAt': startAt,
        'endAt': endAt,
        'document': document,
        'master': master,
      };

  set resume(String resume) => this.resume = resumee;
}
/*
class Meeting {
  final String title;
//  final String description;
  final String resume;
  final List members;
  final Timestamp date;
  final String master;
  final DocumentReference document;

  Meeting({
    required this.title,
//    required this.description,
    required this.resume,
    required this.members,
    required this.date,
    required this.master,
    required this.document,
  });

  set resume(String resume) => this.resume = resume;
}
*/

class HomeModel {
  final List<Meeting> _meetings = [];

  List<Meeting> get meetings => _meetings;

  void addNewMeeting(Meeting meeting) => _meetings.add(meeting);
}
