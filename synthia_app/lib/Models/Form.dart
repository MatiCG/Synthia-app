import 'package:uuid/uuid.dart';

var uuid = Uuid();

class MeetingData {
  String meetingId = uuid.v1();
  String meetingTitle;
  String meetingSubject;
  String meetingSchedule;

  MeetingData({
    this.meetingTitle,
    this.meetingSubject,
    this.meetingSchedule
  });

  // Setters
  void setMeetingTitle(title) {
    this.meetingTitle = title;
  }
  void setMeetingSubject(subject) {
    this.meetingSubject = subject;
  }
  void setMeetingSchedule(schedule) {
    this.meetingSchedule = schedule;
  }

  // Getters
  String getMeetingTitle() {
    return this.meetingTitle;
  }
  String getMeetingSubject() {
    return this.meetingSubject;
  }
  String getMeetingSchedule() {
    return this.meetingSchedule;
  }

  // Get data as JSON
  Map<String, Map<String, dynamic>> getData() => {
    this.meetingId: {
      'title': this.meetingTitle,
      'subject': this.meetingSubject,
      'schedule': this.meetingSchedule
    }
  };
}