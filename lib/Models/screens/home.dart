import 'package:synthiapp/Classes/meeting.dart';

class HomeModel {
  final List<Meeting> _meetings = [];

//  List<Meeting> get meetings => _meetings;
  List<Meeting> get meetings {
    final today = DateTime.now();
    _meetings.sort((a, b) {
      final meetingA = DateTime(
        a.date!.year,
        a.date!.month,
        a.date!.day,
        a.endAt!.hour,
        a.endAt!.minute,
      );
      final meetingB = DateTime(
        b.date!.year,
        b.date!.month,
        b.date!.day,
        b.endAt!.hour,
        b.endAt!.minute,
      );

      final timeA = meetingA.difference(today).inSeconds;
      final timeB = meetingB.difference(today).inSeconds;

      if (timeA.isNegative) return 1;
      if (timeB.isNegative) return 0;
      return timeA.compareTo(timeB);
    });
    return _meetings;
  }

  void addNewMeeting(Meeting meeting) => _meetings.add(meeting);
}
