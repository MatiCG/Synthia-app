import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/config/config.dart';

/// Initiate HomeController with the [parent]
class HomeController {
  final State<StatefulWidget> parent;
  final HomeModel model = HomeModel();

  HomeController(this.parent) {
    getMeetingList();
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

  getMeetingList() async {
    SynthiaFirebase _firebase = SynthiaFirebase();
    List<DocumentSnapshot>? meetings = await _firebase.fetchMeetings();

    if (meetings != null) {
      await Future.wait(
        meetings.map((meeting) async {
          if (checkKeysExist(meeting, ['title', 'members', 'schedule'])) {
            DocumentReference ref = (meeting.data() as Map)['members'][0];

            String masterFullName = await _firebase.fetchUserRefDataByType(
              ref, UserRefData.fullname);

            Meeting newMeeting = Meeting(
              document: meeting.reference,
              title: (meeting.data() as Map<String, dynamic>)['title'],
              date: (meeting.data() as Map<String, dynamic>)['schedule'],
              master: masterFullName, //'$masterFirstName $masterLastName',
            );

            if (parent.mounted &&
                model.meetings
                        .where((element) => element.title == newMeeting.title)
                        .length <=
                    0) {
              // ignore: invalid_use_of_protected_member
              parent.setState(() {
                model.addNewMeeting = newMeeting;
              });
            }
          }
        }),
      );
    }
  }

  /// Check each meeting that start the today's date
  int getMeetingsOfTheDay() {
    final DateTime date = DateTime.now();
    final String todayDate = '${DateFormat('dd/MM/yyyy').format(date)}';
    int counter = 0;

    model.meetings.forEach((meeting) {
      String meetingDate =
          DateFormat('dd/MM/yyyy').format(meeting.date.toDate());

      if (meetingDate == todayDate) {
        counter++;
      }
    });

    return counter;
  }

  Future<int> getInvitations() async {
    List<DocumentSnapshot>? invitations =
        await SynthiaFirebase().fetchInvitations();

    if (invitations != null) {
      return invitations.length;
    }
    return 0;
  }

  int getAllMeetings() {
    return 30;
  }

  /// Get the user's firstname
  String getUserFirstname() {
    return '${user.data?.displayName?.split(' ').first ?? ''}';
  }

  /// Get the user's photo path
  String getUserPhotoPath() {
    return '${user.data?.photoURL?.contains('https') == true ? 'assets/avatars/avatar_05.png' : user.data?.photoURL ?? 'assets/avatars/avatar_05.png'}';
  }
}
