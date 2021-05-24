import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Models/screens/invitations.dart';

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
  void dismissInvitation(DocumentSnapshot invitation) async {
    const String collection = 'invitations';
    final String document = invitation.id;

    try {
      await _firestore.collection(collection).doc(document).delete();
    } catch (error) {
      print('[error invitation delete] $error');
    }
  }

  /// Add the current who accept the [invitation] in the list of
  /// participants
  /// Also delete the [invitation] in the database
  void acceptInvitation(DocumentSnapshot invitation) async {
    final List<String> keys = ['meeting', 'user'];

    /// Check if the [invitation] snapshot is valid and contains the [keys]
    if (_firebase.checkSnapshotDocument(invitation, keys: keys)) {
      final Map<String, dynamic> data =
          (invitation.data()! as Map<String, dynamic>);
      final DocumentReference meeting = data['meeting'];
      final DocumentReference user = data['user'];

      try {
        await _firestore.doc(meeting.path).update({
          'members': FieldValue.arrayUnion([user]),
        });
        this.dismissInvitation(invitation);
      } catch (error) {
        print('[error invitation accept] $error');
      }
    }
  }

  void initInvitationTile() async {
    final DocumentSnapshot<Object?>? invitation = model.invitationSelected;

    if (invitation == null) return;

    await _fetchDataFromMaster(invitation);
    await _fetchDataFromMeeting(invitation);
    await _fetchInvitationDate(invitation);
  }

  /// Function associated to [initInvitationTile]
  _fetchInvitationDate(DocumentSnapshot<Object?> invitation) async {
    if (_firebase.checkSnapshotDocument(invitation, keys: ['timestamp'])) {
      Timestamp time = (invitation.data()! as Map)['timestamp'];

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
  _fetchDataFromMeeting(DocumentSnapshot<Object?> invitation) async {
    if (_firebase.checkSnapshotDocument(invitation, keys: ['meeting'])) {
      DocumentReference meeting =
          (invitation.data()! as Map<String, dynamic>)['meeting'];
      DocumentSnapshot snapshot = await meeting.get();

      if (_firebase
          .checkSnapshotDocument(snapshot, keys: ['schedule', 'title'])) {
        Timestamp date = (snapshot.data()! as Map)['schedule'];
        String title = (snapshot.data()! as Map)['title'];

        // ignore: invalid_use_of_protected_member
        parent.setState(() {
          model
            ..meetingTitle = title
            ..meetingDate =
                DateFormat('d MMMM y à').add_Hm().format(date.toDate());
        });
      }
    }
  }

  /// Function associated to [initInvitationTile]
  /// Retrieve data from the [master].
  ///   - fullname
  ///   - photoUrl
  _fetchDataFromMaster(DocumentSnapshot<Object?> invitation) async {
    if (_firebase.checkSnapshotDocument(invitation, keys: ['master'])) {
      Map<String, dynamic> data = invitation.data()! as Map<String, dynamic>;

      String fullname = await _firebase.fetchUserRefDataByType(
          data['master'], UserRefData.fullname);
      String photoUrl = await _firebase.fetchUserRefDataByType(
          data['master'], UserRefData.photoUrl);

      // ignore: invalid_use_of_protected_member
      parent.setState(() {
        model
          ..masterFullname = fullname
          ..masterPhotoUrl = photoUrl;
      });
    }
  }
}
