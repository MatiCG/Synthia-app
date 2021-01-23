import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Classes/utils.dart';
import 'package:synthiaapp/Controllers/detail_page.dart';
import 'package:synthiaapp/Views/raspberry_communication.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DetailPageController _controller = DetailPageController();

  Future emailPopUp(BuildContext context) {
    TextEditingController customController = new TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Email"),
          content: TextField(
            controller: customController,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Share"),
              onPressed: () => _controller.shareMeeting(
                  context, widget.post, customController),
            )
          ],
        );
      },
    );
  }

  Widget topContentText() {
    return Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 120.0),
          Icon(
            Icons.assignment,
            color: Colors.white,
            size: 40.0,
          ),
          Container(
            width: 90.0,
            child: new Divider(color: Colors.green),
          ),
          SizedBox(height: 10.0),
          Text(
            widget.post.data["title"],
            style: TextStyle(color: Colors.white, fontSize: 45.0),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Widget bottomContentText() {
    return Container(
      child: Text(
        widget.post.data["description"],
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget bottomContentButton() {
    return Container(
      child: Column(
        children: [
          RaisedButton(
            //onPressed: () => navigateToEditOrder(widget.post),
            color: Color.fromRGBO(58, 66, 86, 1.0),
            child: Text("SEE AND EDIT ORDER",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget bottomContent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText(), bottomContentButton()],
        ),
      ),
    );
  }

  Widget topContent() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10.0),
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/meeting.jpeg"),
                  fit: BoxFit.cover,
                ),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            padding: EdgeInsets.all(0.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
            child: Center(
              child: topContentText(),
            ),
          ),
          Positioned(
            left: 8.0,
            top: 60.0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            right: 8.0,
            top: 60.0,
            child: InkWell(
              onTap: () {
                emailPopUp(context);
              },
              child: Icon(Icons.share, color: Colors.white),
            ),
          ),
          Positioned(
              right: 8.0,
              bottom: 10,
              child: Text(widget.post.data["schedule"],
                  style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          topContent(),
          bottomContent(),
          buildStartMeetingBtn(),
        ],
      ),
    );
  }

  /// Open the page that start the communication
  /// With the raspberry pi
  buildStartMeetingBtn() {
    return FlatButton(
      child: Text('Start Meeting'),
      onPressed: () {
        Utils().pushScreen(context, RspyCommunication());
      },
    );
  }
}
