import 'package:cloud_firestore/cloud_firestore.dart';

class Meeting {
  final String title;
  final Timestamp date;
  final String master;
  final DocumentReference document;

  Meeting({
    required this.title,
    required this.date,
    required this.master,
    required this.document,
  });
}

class HomeModel {
  List<Meeting> _meetings = [];

  List<Meeting> get meetings => _meetings;

  set addNewMeeting(Meeting meeting) => _meetings.add(meeting);
}
