import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiapp/config/config.dart';

enum UserRefData {
  email,
  firstname,
  lastname,
  photoUrl,
  fullname,
}

extension UserRefExt on UserRefData {
  List<String> get keys {
    switch (this) {
      case UserRefData.email:
        return ['email'];
      case UserRefData.firstname:
        return ['firstname'];
      case UserRefData.lastname:
        return ['lastname'];
      case UserRefData.photoUrl:
        return ['photoUrl'];
      case UserRefData.fullname:
        return ['firstname', 'lastname'];
    }
  }
}

class SynthiaFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send a invitation to the [targetUser].
  /// Must give the [master] and the [meeting] reference
  Future sendInvitation({
    required DocumentReference targetRef,
    required DocumentReference masterRef,
    required DocumentReference meetingRef,
  }) async {
    await FirebaseFirestore.instance.collection('invitations').add({
      'user': targetRef,
      'master': masterRef,
      'meeting': meetingRef,
      'timestamp': Timestamp.now(),
    });
  }

  /// Fetch all the invitations of the [userRef] for the [meetingRef]
  Future<int> fetchUserInvitations(
      DocumentReference userRef, DocumentReference meetingRef) async {
    final data = await _firestore.collection('invitations').get();
    int invitations = 0;

    for (final document in data.docs) {
      if (checkSnapshotDocument(document, keys: ['user', 'meeting'])) {
        final snapData = document.data();

        if (snapData['meeting'] == meetingRef && snapData['user'] == userRef) {
          invitations += 1;
        }
      }
    }

    return invitations;
  }

  /// Fetch the userReference using his email to find him
  Future<DocumentReference?> fetchUserReferenceByEmail(String? email) async {
    if (email == null || email.isEmpty) return null;
    final value = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (value.docs.isEmpty) return null;
    return value.docs.first.reference;
  }

  /// Retrieve the [photoUrl] of the [userRef]
  Future<String?> fetchUserReferencePhotoUrl(DocumentReference userRef) async {
    final data = await _firestore.collection('users').doc(userRef.id).get();

    if (checkSnapshotDocument(data, keys: ['photoUrl'])) {
      return data.data()!['photoUrl'] as String;
    }
    return null;
  }

  /// Retrieve all the meetings where the current user is
  Future<List<DocumentReference>> fetchUserMeetings() async {
    final userRef = _firestore.collection('users').doc(user.uid);

    final List<DocumentReference> list = [];
    final QuerySnapshot data = await _firestore
        .collection('meetings')
        .where('members', arrayContains: userRef)
        .get();

    for (final document in data.docs) {
      list.add(document.reference);
    }
    return list;
  }

  Future<Map?> fetchUserRefData(DocumentReference reference) async {
    final DocumentSnapshot snapshot = await reference.get();

    if (checkSnapshotDocument(snapshot,
        keys: ['email', 'firstname', 'lastname', 'photoUrl'])) {
      final Map<String, dynamic> data =
          snapshot.data()! as Map<String, dynamic>;

      return data;
    }
    return null;
  }

  Future<String> fetchUserRefDataByType(
      DocumentReference reference, UserRefData type) async {
    final DocumentSnapshot snapshot = await reference.get();
    final List<String> keys = type.keys;

    if (checkSnapshotDocument(snapshot, keys: keys)) {
      final List<String> values = [];
      final Map<String, dynamic> data =
          snapshot.data()! as Map<String, dynamic>;

      if (keys.length == 1) return data[keys[0]] as String;

      for (final key in keys) {
        values.add(data[key] as String);
      }
      return values.join(' ');
    }
    return 'error fetch';
  }

  Future findRightsInDocuments({
    required final List<dynamic> documents,
    required Function(String right) callback,
  }) async {
    await Future.wait(
      documents.map((document) async {
        if (document is DocumentReference) {
          final DocumentSnapshot data = await document.get();

          callback(data['title'] as String);
        }
      }),
    );
  }

  DocumentReference getUserReference() {
    return _firestore.collection('users').doc(user.uid);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchReportResumeStream(DocumentReference meeting) {
    return _firestore.doc(meeting.path).snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> fetchStreamMeetings() {
    return _firestore
        .collection('meetings')
        .where('members', arrayContains: getUserReference())
        .snapshots();
  }

  Future<List<DocumentSnapshot>?> fetchMeetings() async {
    if (user.data != null) {
      final List<DocumentSnapshot> meetings = (await _firestore
              .collection('meetings')
              .where('members', arrayContains: getUserReference())
              .get())
          .docs;

      return meetings;
    }
    return null;
  }

  Future<DocumentSnapshot?> fetchMeetingById(String meetingId) async {
    if (user.data != null) {
      final DocumentSnapshot meetings =
          await _firestore.collection('meetings').doc(meetingId).get();

      return meetings;
    }
    return null;
  }

  Stream<QuerySnapshot> fetchStreamInvitations() {
    final DocumentReference userRef =
        _firestore.collection('users').doc(user.uid);
    final Stream<QuerySnapshot> stream = _firestore
        .collection('invitations')
        .where('user', isEqualTo: userRef)
        .snapshots();

    return stream;
  }

  Future<List<DocumentSnapshot>?> fetchInvitations() async {
    final DocumentReference userRef =
        _firestore.collection('users').doc(user.uid);
    final List<DocumentSnapshot> invitation = (await _firestore
            .collection('invitations')
            .where('user', isEqualTo: userRef)
            .get())
        .docs;

    return invitation;
  }

  /// Check if the [documentSnapshot] is valid
  bool isDocumentValid(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists && documentSnapshot.data() != null) return true;
    return false;
  }

  /// Check if the [documentSnapshot] contains all the [keys] asked
  bool hasKeys(DocumentSnapshot documentSnapshot, List<String> keys) {
    bool keyMissing = false;

    for (final key in keys) {
      if (!(documentSnapshot.data()! as Map<String, dynamic>)
          .containsKey(key)) {
        keyMissing = true;
      }
    }
    return !keyMissing;
  }

  /// Check if the [snapshot document] is not empty and have the [keys]
  bool checkSnapshotDocument(DocumentSnapshot documentSnapshot,
      {List<String>? keys}) {
    if (isDocumentValid(documentSnapshot) &&
        hasKeys(documentSnapshot, keys ?? [])) return true;
    return false;
  }

  /// Check if the [document] is valid and contains all the [keys]
  Future<DocumentSnapshot?> getDocumentAndVerifyKeys(
      DocumentReference? document, List<String> keys) async {
    if (document == null) return null;
    final DocumentSnapshot documentSnapshot = await document.get();

    if (checkSnapshotDocument(documentSnapshot, keys: keys)) {
      return documentSnapshot;
    }
    return null;
  }
}
