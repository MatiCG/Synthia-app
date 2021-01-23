import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class EditOrderController{
  final Firestore firestore = Firestore.instance;

  Future<NotusDocument> loadDocument(DocumentSnapshot post) async {
    return firestore.collection("meetings").where('title', isEqualTo: post.data['title']).getDocuments().then((QuerySnapshot meetings) {
      return NotusDocument.fromJson(
          jsonDecode(meetings.documents[0].data["order"]));
    }).catchError((onError) {
      final Delta delta = Delta()..insert("Order failed on load\n");
      return NotusDocument.fromDelta(delta);
    });
  }

  void saveDocument(context, ZefyrController _zefyrcontroller, DocumentSnapshot post) {
    final contents = jsonEncode(_zefyrcontroller.document);
    firestore.collection("meetings").where('title', isEqualTo: post.data['title']).getDocuments().then((QuerySnapshot meetings) {
      firestore.collection("meetings").document(meetings.documents[0].documentID).updateData({"order": contents}).then((_) {
        Scaffold.of(context).showSnackBar(SnackBar(content : Text("Saved.")));
      });
    });
  }
}