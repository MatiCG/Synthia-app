import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Classes/auth.dart';

class HomeModel {
  /// Return the list of the meetings
  /// of the current user
  Future<List<DocumentSnapshot>> getMeetingsList() async {
    final Firestore firestore = Firestore.instance;
    QuerySnapshot querySnapshot;

    try {
      querySnapshot = await firestore
          .collection('meetings')
          .where('members', arrayContains: await Auth().currentUserEmail())
          .getDocuments();
      return querySnapshot.documents;
    } catch (error) {
      print('An error occured retrieving meetings list. $error');
      return null;
    }
  }
}
