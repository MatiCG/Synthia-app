import 'package:flutter/material.dart';
import 'package:synthiapp/Models/screens/detail_meeting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';

class DetailMeetingController {
  final String meetingId;
  final State<StatefulWidget> parent;
  final DetailMeetingModel model = DetailMeetingModel();

  DetailMeetingController(this.parent, this.meetingId) {
    getMeeting();
  }

  getMeeting() async {
    SynthiaFirebase _firebase = SynthiaFirebase();
    DocumentSnapshot? meeting = await _firebase.fetchMeetingById(meetingId);

    if (meeting != null) {
      if (checkKeysExist(meeting,
          ['title', 'members', 'schedule', 'order', 'description', 'note'])) {
        List<dynamic> members = (meeting.data() as Map)['members'];
        List<String> membersName = [];

        members.forEach((element) async {
          String memberName = await _firebase.fetchUserRefDataByType(
              element, UserRefData.fullname);
          print(memberName);
          membersName.add(memberName);
        });
        if (parent.mounted) {
          parent.setState(() {
            model.setMembers = membersName;
            model.setTitle = (meeting.data() as Map<String, dynamic>)['title'];
            model.setDescription =
                (meeting.data() as Map<String, dynamic>)['description'];
            model.setOrder = (meeting.data() as Map<String, dynamic>)['order'];
            model.setNote = (meeting.data() as Map<String, dynamic>)['note'];
            model.setResume =
                (meeting.data() as Map<String, dynamic>)['resume'];
            model.setKeywords =
                (meeting.data() as Map<String, dynamic>)['keywords'];
            model.setDate =
                (meeting.data() as Map<String, dynamic>)['schedule'];
          });
        }
      }
    }
  }

  bool checkKeysExist(DocumentSnapshot document, List<String> keys) {
    bool notMissingOne = true;
    Map<String, dynamic> data;

    if (document.data() == null) return false;
    data = document.data() as Map<String, dynamic>;
    keys.forEach((key) {
      if (!data.containsKey(key)) {
        notMissingOne = false;
      }
    });
    return notMissingOne;
  }

  bool isMeetingComplete() {
    if (model.resume != '' || model.keywords != '') return true;
    return false;
  }
}
