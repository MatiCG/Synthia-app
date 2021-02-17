import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:synthiaapp/Models/home.dart';

class HomeController {
  final dynamic parent;
  HomeModel model;

  HomeController({this.parent}) {
    model = HomeModel(parent: parent);
  }

  /// Update meetings list
  void updateMeetingList() {
    model.getMeetings().then((value) {
      parent.setState(() {
        model.meetings = value;
      });
    });
  }

  /// Get the leader of the meeting
  String getMeetingLeader(DocumentSnapshot meeting) {
    return meeting.data()['members'][0];
  }

  /// Get the date when meeting has been created
  String getMeetingDate(DocumentSnapshot meeting) {
    final DateTime now =
        DateFormat("dd/MM/yyyy").parse(meeting.data()['schedule']);
    final DateFormat formatter = DateFormat('d MMM y');

    return formatter.format(now);
  }

  /// Get the meetings of the day
  String getTodayMeetings() {
    if (model.meetings.length == 0) {
      return 'No meetings !';
    }
    return '${model.meetings.length} meetings';
  }
}
