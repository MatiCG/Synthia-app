import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Models/screens/invitations.dart';
import 'package:synthiapp/config/config.dart';

class InvitationController {
  final State<StatefulWidget> parent;
  final InvitationModel model = InvitationModel();
  final SynthiaFirebase _firebase = SynthiaFirebase();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InvitationController(this.parent) {
    _firebase.fetchInvitations().then((data) {
      // ignore: invalid_use_of_protected_member
      parent.setState(() {
        model.invitations = data;
      });
    });
  }

  /// Delete the [invitation] in the database.
  Future dismissInvitation(DocumentSnapshot invitation) async {
    const String collection = 'invitations';
    final String document = invitation.id;

    try {
      await _firestore.collection(collection).doc(document).delete();
    } catch (error) {
      log('[error invitation delete] $error');
    }
  }

  /// Add the current who accept the [invitation] in the list of
  /// participants
  /// Also delete the [invitation] in the database
  Future acceptInvitation(DocumentSnapshot invitation) async {
    final List<String> keys = ['meeting', 'user'];

    /// Check if the [invitation] snapshot is valid and contains the [keys]
    if (_firebase.checkSnapshotDocument(invitation, keys: keys)) {
      final data = invitation.data()! as Map<String, dynamic>;
      final DocumentReference meeting = data['meeting'] as DocumentReference;
      final DocumentReference user = data['user'] as DocumentReference;

      try {
        await _firestore.doc(meeting.path).update({
          'members': FieldValue.arrayUnion([user]),
        });
        dismissInvitation(invitation);
      } catch (error) {
        log('[error invitation accept] $error');
      }
    }
  }

  Future initInvitationTile() async {
    final DocumentSnapshot<Object?>? invitation = model.invitationSelected;

    if (invitation == null) return;
    await _fetchDataFromMaster(invitation);
    await _fetchDataFromMeeting(invitation);
    await _fetchInvitationDate(invitation);
  }

  /// Function associated to [initInvitationTile]
  Future _fetchInvitationDate(DocumentSnapshot<Object?> invitation) async {
    if (_firebase.checkSnapshotDocument(invitation, keys: ['timestamp'])) {
      final Timestamp time =
          (invitation.data()! as Map)['timestamp'] as Timestamp;

      // ignore: invalid_use_of_protected_member
      parent.setState(() {
        model.invitationDate = DateFormat('d MMMM').format(time.toDate());
      });
    }
  }

  /// Function associated to [initInvitationTile]
  /// Retrieve data from the [meeting]
  ///   - title
  ///   - date
  Future _fetchDataFromMeeting(DocumentSnapshot<Object?> invitation) async {
    if (_firebase.checkSnapshotDocument(invitation, keys: ['meeting'])) {
      final data = invitation.data()! as Map<String, dynamic>;
      final DocumentReference meeting = data['meeting'] as DocumentReference;
      final DocumentSnapshot snapshot = await meeting.get();

      if (_firebase.checkSnapshotDocument(snapshot, keys: ['date', 'title'])) {
        final data = snapshot.data()! as Map;
        log('DATA: $data');
        final Timestamp date = data['date'] as Timestamp;
        final Timestamp start = data['startAt'] as Timestamp;
        final String title = data['title'] as String;

        utils.updateView(parent, update: () {
          model
            ..meetingTitle = title
            ..meetingDate = '${DateFormat('d MMMM y à ').format(date.toDate())}${'${start.toDate().hour}:${start.toDate().minute}'}';
        });
      }
    }
  }

  /// Function associated to [initInvitationTile]
  /// Retrieve data from the [master].
  ///   - fullname
  ///   - photoUrl
  Future _fetchDataFromMaster(DocumentSnapshot<Object?> invitation) async {
    if (_firebase.checkSnapshotDocument(invitation, keys: ['master'])) {
      final data = invitation.data()! as Map<String, dynamic>;
      final DocumentReference masterRef = data['master'] as DocumentReference;

      final String fullname = await _firebase.fetchUserRefDataByType(
          masterRef, UserRefData.fullname);
      final String photoUrl = await _firebase.fetchUserRefDataByType(
          masterRef, UserRefData.photoUrl);

      utils.updateView(parent, update: () {
        model
          ..masterFullname = fullname
          ..masterPhotoUrl = photoUrl;
      });
    }
  }
}
