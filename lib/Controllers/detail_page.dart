import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DetailPageController {
  //final DetailPageModel _model = DetailPageModel();

  void shareMeeting(
      context, DocumentSnapshot post, TextEditingController customController) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
        .collection('meetings')
        .where('title', isEqualTo: post.data()['title'])
        .get()
        .then((value) {
      firestore.collection('meetings').doc().update({
        'members': FieldValue.arrayUnion([customController.text.toString()])
      });
    });
    Navigator.of(context).pop();
/*
      firestore
          .collection("meetings")
          .where('title', isEqualTo: post.data['title'])
          .getDocuments()
          .then((QuerySnapshot meetings) {
            firestore
                .collection("meetings")
                .document(meetings.documents[0].documentID)
                .updateData({
              "members": FieldValue.arrayUnion(
                  [customController.text.toString()])
            }).then((_) {});
      });
      Navigator.of(context).pop();
*/
  }
}
