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
  get keys {
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
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  fetchUserRefDataByType(DocumentReference reference, UserRefData type) async {
    final DocumentSnapshot snapshot = await reference.get();
    final List<String> keys = type.keys;

    if (checkSnapshotDocument(snapshot, keys: keys)) {
      final Map<String, dynamic> data =
          snapshot.data()! as Map<String, dynamic>;

      if (keys.length == 1) return data[keys[0]];
      List<String> values = [];

      keys.forEach((key) {
        values.add(data[key]);
      });

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
