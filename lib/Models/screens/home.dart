
import 'package:synthiapp/Classes/meeting.dart';

class HomeModel {
  final List<Meeting> _meetings = [];

  List<Meeting> get meetings => _meetings;

  void addNewMeeting(Meeting meeting) => _meetings.add(meeting);
}
