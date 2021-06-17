import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    late Map<String, dynamic> data;

    if (document.data() == null) return false;
    data = document.data()! as Map<String, dynamic>;

    for (final key in keys) {
      if (!data.containsKey(key)) {
        notMissingOne = false;
      }
    }
    return notMissingOne;
  }

  /*
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return new ListTile(
                title: new Text(data['full_name']),
                subtitle: new Text(data['company']),
              );
            }).toList(),
          );
        },
      );
    }
  */

  Future getMeetingListFromSnapshot(
      List<QueryDocumentSnapshot<Object?>>? meetings) async {
    final SynthiaFirebase _firebase = SynthiaFirebase();

    if (meetings != null) {
      await Future.wait(
        meetings.map((meeting) async {
          if (checkKeysExist(meeting, ['title', 'description', 'members', 'resume', 'members', 'schedule'])) {
            final data = meeting.data()! as Map;
            final DocumentReference ref =
                data['members'][0] as DocumentReference;
            final String masterFullName = await _firebase
                .fetchUserRefDataByType(ref, UserRefData.fullname);
            final Meeting newMeeting = Meeting(
              document: meeting.reference,
              title: data['title'] as String,
              description: data['description'] as String,
              members: data['members'] as List,
              resume: data['resume'] as String,
              date: data['schedule'] as Timestamp,
              master: masterFullName,
            );

            if (parent.mounted && model.meetings.where((element) => element.title == newMeeting.title).isEmpty) {
              utils.updateView(parent, update: () {
                model.addNewMeeting(newMeeting);
                model.meetings.sort((a, b) => a.date.compareTo(b.date));
              });
            }
          }
        }),
      );
    }
  }

  Future getMeetingList() async {
    final SynthiaFirebase _firebase = SynthiaFirebase();
    final List<DocumentSnapshot>? meetings = await _firebase.fetchMeetings();

    if (meetings != null) {
      await Future.wait(
        meetings.map((meeting) async {
          if (checkKeysExist(meeting, ['title', 'description', 'members', 'resume', 'members', 'schedule'])) {
            final data = meeting.data()! as Map<String, dynamic>;
            final DocumentReference ref = data['members'][0] as DocumentReference;
            final String masterFullName = await _firebase.fetchUserRefDataByType(
                ref, UserRefData.fullname);
            final Meeting newMeeting = Meeting(
              document: meeting.reference,
              title: data['title'] as String,
              description: data['description'] as String,
              members: data['members'] as List,
              resume: data['resume'] as String,
              date: data['schedule'] as Timestamp,
              master: masterFullName,
            );

            if (parent.mounted && model.meetings.where((element) => element.title == newMeeting.title).isEmpty) {
              // ignore: invalid_use_of_protected_member
              parent.setState(() {
                model.addNewMeeting(newMeeting);
                model.meetings.sort((a, b) {
                  final date = Timestamp.fromDate(DateTime.now());

                  if (a.date.compareTo(date) == 0) {
                    return a.date.compareTo(b.date);
                  }
                  return -1;
                });
              });
            }
          }
        }),
      );
    }
  }

  /// Check each meeting that start the today's date
  int getMeetingsOfTheDay() {
    int counter = 0;

    for (final meeting in model.meetings) {
      final meetingDate = meeting.date.toDate();
      final currentDate = DateTime.now();
      final timeleft = meetingDate.difference(currentDate);

      if (timeleft.inSeconds > 0 && meetingDate.day == currentDate.day) {
        counter++;
      }
    }
    return counter;
  }

  Future<int> getInvitationsFromSnapshot(
      List<QueryDocumentSnapshot<Object?>>? invitations) async {
//    List<DocumentSnapshot>? invitations =
    //      await SynthiaFirebase().fetchInvitations();

    if (invitations != null) {
      return invitations.length;
    }
    return 0;
  }

  Future<int> getInvitations() async {
    final List<DocumentSnapshot>? invitations =
        await SynthiaFirebase().fetchInvitations();

    if (invitations != null) {
      return invitations.length;
    }
    return 0;
  }

  Future<int> getAllMeetings() async {
    final meetings = await SynthiaFirebase().fetchUserMeetings();

    return meetings.length;
  }

  /// Get the user's firstname
  String getUserFirstname() {
    return user.data?.displayName?.split(' ').first ?? '';
  }

  /// Get the user's photo path
  String getUserPhotoPath() {
    return user.data?.photoURL?.contains('https') == true ? 'assets/avatars/avatar_05.png' : user.data?.photoURL ?? 'assets/avatars/avatar_05.png';
  }
}
