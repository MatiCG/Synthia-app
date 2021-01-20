import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:synthiaapp/Models/home.dart';

class HomeController {
  final HomeModel _model = HomeModel();

  /// Get the list of the meetings from the db
  ///  and store them in the model
  Future<void> retrieveMeetingsList() async {
    List<DocumentSnapshot> meetings = await _model.getMeetingsList();
    _model.setMeetings(meetings);
  }

  /// Get the currents meetings
  List<DocumentSnapshot> getMeetings() {
    return _model.getMeetings();
  }

  /// Get the leader of the meeting
  String getMeetingLeader(DocumentSnapshot meeting) {
    return meeting.data['members'][0];
  }

  /// Get the date when meeting has been created
  String getMeetingDate(DocumentSnapshot meeting) {
    final DateTime now = DateFormat("dd/MM/yyyy").parse(
        meeting.data['schedule']);
    final DateFormat formatter = DateFormat('d MMM y');

    return formatter.format(now);
  }

  /// Get the meetings of the day
  List<dynamic> getTodayMeetings() {
    return [1, 2, 3];
  }
}
