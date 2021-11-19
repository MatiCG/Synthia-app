import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Models/screens/settings.dart';
import 'package:synthiapp/config/config.dart';

class SettingsController {
  final SettingsModel model = SettingsModel();

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
}
