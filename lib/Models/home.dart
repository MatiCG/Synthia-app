import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/config.dart';

class HomeModel {
  List<DocumentSnapshot> meetings = [];
  final dynamic parent;

  HomeModel({this.parent}) {
    getMeetings().then((value) {
      parent.setState(() {
        meetings = value;
      });
    });
  }

  Future<List<DocumentSnapshot>> getMeetings() async {
    try {
//      List<DocumentSnapshot> result;
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('meetings')
          .where('members', arrayContains: auth.user.email)
          .get();
      return result.docs;
    } catch (error) {
      print('An error occured retrieving meetings list. $error');
      return null;
    }
  }
}
