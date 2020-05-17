import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {

  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState()=> _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.post.data["title"])
      ),
      body: Container(
        child: ListTile(
          title: Text(widget.post.data["title"]),
          subtitle: Text(widget.post.data["description"]),
        ),
      ),
    );
  }
}
