import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'dart:io';

class EditOrder extends StatefulWidget {

  final DocumentSnapshot post;

  EditOrder({this.post});

  @override
  _EditOrderState createState()=> _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  ZefyrController _controller;
  FocusNode _focusNode;
  var firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = (_controller == null)
        ? Center (child: CircularProgressIndicator())
        : ZefyrScaffold(
      child: ZefyrEditor(
        padding: EdgeInsets.all(16),
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Order"),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          )
        ],
      ),
      body: body,
    );
  }

  Future<NotusDocument> _loadDocument() async {
    return firestore.collection("meetings").where('title', isEqualTo: widget.post.data['title']).getDocuments().then((QuerySnapshot meetings) {
      return NotusDocument.fromJson(
          jsonDecode(meetings.documents[0].data["order"]));
    }).catchError((onError) {
      final Delta delta = Delta()..insert("Order failed on load\n");
      return NotusDocument.fromDelta(delta);
    });
  }

  void _saveDocument(BuildContext context) {
    final contents = jsonEncode(_controller.document);
    firestore.collection("meetings").where('title', isEqualTo: widget.post.data['title']).getDocuments().then((QuerySnapshot meetings) {
        firestore.collection("meetings").document(meetings.documents[0].documentID).updateData({"order": contents}).then((_) {
          Scaffold.of(context).showSnackBar(SnackBar(content : Text("Saved.")));
        });
    });
  }
}