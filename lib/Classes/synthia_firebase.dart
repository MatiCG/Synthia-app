import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiapp/config/config.dart';

class SynthiaFirebase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> fetchUserRefFullName(DocumentReference ref) async {
    if (checkSnapshotDocument(await ref.get(),
        keys: ['firstname', 'lastname'])) {
      var data = ((await ref.get()).data()! as Map<String, dynamic>);

      return '${data['firstname']} ${data['lastname']}';
    }
    return '';
  }

  Future<String> fetchUserRefEmail(DocumentReference ref) async {
    if (checkSnapshotDocument(await ref.get(), keys: ['email'])) {
      return ((await ref.get()).data()! as Map<String, dynamic>)['email'];
    }
    return '';
  }

  Future<String> fetchUserRefPhotoUrl(DocumentReference ref) async {
    if (checkSnapshotDocument(await ref.get(), keys: ['photoUrl'])) {
      return ((await ref.get()).data()! as Map<String, dynamic>)['photoUrl'];
    }
    return '';
  }

  Future<String> fetchUserRefFirstName(DocumentReference ref) async {
    if (checkSnapshotDocument(await ref.get(), keys: ['firstname'])) {
      return ((await ref.get()).data()! as Map<String, dynamic>)['firstname'];
    }
    return '';
  }

  Future<String> fetchUserRefLastName(DocumentReference ref) async {
    if (checkSnapshotDocument(await ref.get(), keys: ['lastname'])) {
      return ((await ref.get()).data()! as Map<String, dynamic>)['lastname'];
    }
    return '';
  }

  Future findRightsInDocuments({
    required final List<dynamic> documents,
    required Function(String right) callback,
  }) async {
    await Future.wait(
      documents.map((document) async {
        if (document is DocumentReference) {
          DocumentSnapshot data = await document.get();

          callback(data['title']);
        }
      }),
    );
  }

  DocumentReference getUserReference() {
    return _firestore.collection('users').doc(user.uid);
  }

  Future<List<DocumentSnapshot>?> fetchMeetings() async {
    if (user.data != null) {
      List<DocumentSnapshot> meetings = (await FirebaseFirestore.instance
              .collection('meetings')
              .where('members', arrayContains: getUserReference())
              .get())
          .docs;

      return meetings;
    }
    return null;
  }

  Future<List<DocumentSnapshot>?> fetchInvitations() async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    List<DocumentSnapshot> invitation = (await FirebaseFirestore.instance
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

    keys.forEach((key) {
      if (!(documentSnapshot.data()! as Map<String, dynamic>)
          .containsKey(key)) {
        keyMissing = true;
      }
    });

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
    DocumentSnapshot documentSnapshot = await document.get();

    if (checkSnapshotDocument(documentSnapshot, keys: keys))
      return documentSnapshot;
    return null;
  }
}
