import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class EditOrderController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<NotusDocument> loadDocument(DocumentSnapshot post) async {
     return firestore.collection('meetings').doc(post.id).get().then((DocumentSnapshot meetings) {
      return NotusDocument.fromJson(
          jsonDecode(meetings.data()["order"]));
    }).catchError((onError) {
      final Delta delta = Delta()..insert("New Order\n");
      return NotusDocument.fromDelta(delta);
    });
  }

  void saveDocument(context, ZefyrController _zefyrcontroller, DocumentSnapshot post) {
    final contents = jsonEncode(_zefyrcontroller.document);
    firestore.collection('meetings').doc(post.id).update({"order": contents}).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content : Text("Saved.")));
    });
  }
}