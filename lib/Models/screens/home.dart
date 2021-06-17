import 'package:cloud_firestore/cloud_firestore.dart';

class Meeting {
  final String title;
  final String description;
  final String resume;
  final List members;
  final Timestamp date;
  final String master;
  final DocumentReference document;

  Meeting({
    required this.title,
    required this.description,
    required this.resume,
    required this.members,
    required this.date,
    required this.master,
    required this.document,
  });
}

class HomeModel {
  final List<Meeting> _meetings = [];

  List<Meeting> get meetings => _meetings;

  void addNewMeeting(Meeting meeting) => _meetings.add(meeting);
}
