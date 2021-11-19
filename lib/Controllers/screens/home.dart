import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/config/config.dart';

/// Initiate HomeController with the [parent]
class HomeController {
  final State<StatefulWidget> parent;
  final HomeModel model = HomeModel();

  HomeController(this.parent);

  Future<void> deleteAccount() async {
    final DocumentReference userRef = SynthiaFirebase().getUserReference();
    final _firestore = FirebaseFirestore.instance;

    final docs = (await _firestore
            .collection('invitations')
            .where('user', isEqualTo: userRef)
            .get())
        .docs;

    // Delete every invitations
    for (final document in docs) {
      await _firestore.doc(document.reference.path).delete();
    }
    // Delete the users document
    await _firestore.doc(userRef.path).delete();

    final meetingDocs = (await _firestore
            .collection('meetings')
            .where('members', arrayContains: userRef)
            .get())
        .docs;

    // Delete the user in every meeting that is participate
    for (final document in meetingDocs) {
      await _firestore.doc(document.reference.path).update({
        'members': FieldValue.arrayRemove([userRef])
      });
    }
    await user.data?.delete();
    user.signOut();
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

  Future<List<Meeting>> parseMeetingFromSnapshots(
      QuerySnapshot<Object?> snapshot) async {
    final List<Meeting> meetings = [];
    final mandatoryKeys = [
      'title',
      'members',
      'order',
      'note',
      'resume',
      'members',
      'date',
      'startAt',
      'endAt',
    ];

    await Future.wait(
      snapshot.docs.map((snap) async {
        if (checkKeysExist(snap, mandatoryKeys)) {
          final data = snap.data()! as Map;
          final String master = await SynthiaFirebase().fetchUserRefDataByType(
              data['members'][0] as DocumentReference, UserRefData.fullname);

          meetings.add(Meeting(
            document: snap.reference,
            title: data['title'] as String,
            notes: data['note'] as String,
            order: data['order'] as String,
            members: data['members'] as List,
            resumee: data['resume'] as String,
            date: DateTime.fromMillisecondsSinceEpoch(
                (data['date'] as Timestamp).millisecondsSinceEpoch),
            startAt: TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(
                (data['startAt'] as Timestamp).millisecondsSinceEpoch)),
            endAt: TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(
                (data['endAt'] as Timestamp).millisecondsSinceEpoch)),
            master: master,
          ));
        }
      }),
    );

    return meetings;
  }

  /// Check each meeting that start the today's date
  int getMeetingsOfTheDay() {
    int counter = 0;

    for (final meeting in model.meetings) {
      final meetingDate = meeting.date; //!.toDate();
      final currentDate = DateTime.now();
      final timeleft = meetingDate?.difference(currentDate);

      if (timeleft != null &&timeleft.inSeconds > 0 && meetingDate!.day == currentDate.day) {
        counter++;
      }
    }
    return counter;
  }

  Future<int> getInvitationsFromSnapshot(
      List<QueryDocumentSnapshot<Object?>>? invitations) async {

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
    return user.data?.photoURL?.contains('https') == true
        ? 'assets/avatars/avatar_05.png'
        : user.data?.photoURL ?? 'assets/avatars/avatar_05.png';
  }
}
