import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Classes/auth.dart';

class HomeModel {
  List<DocumentSnapshot> _meetings;

  HomeModel() {
    this._meetings = List<DocumentSnapshot>();
  }

  /// Set the meetings list
  void setMeetings(List<DocumentSnapshot> meetings) {
    this._meetings = meetings;
  }

  /// Return the list of the meetings
  List<DocumentSnapshot> getMeetings() {
    return this._meetings;
  }

  /// Return the list of the meetings store in the
  /// database
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
