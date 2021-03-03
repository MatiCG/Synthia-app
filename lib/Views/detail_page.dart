import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Classes/download_file.dart';
import 'package:synthiaapp/Classes/utils.dart';
import 'package:synthiaapp/Controllers/detail_page.dart';
import 'package:synthiaapp/Views/raspberry_communication.dart';

import 'edit_order.dart';

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
            widget.post.data()["title"],
            style: TextStyle(color: Colors.white, fontSize: 45.0),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Widget bottomContentText() {
    return Column(
      children: [
        Text(
          widget.post.data()['description'],
          style: TextStyle(fontSize: 18.0),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            maxWidth:
                double.infinity, //MediaQuery.of(context).size.width * 0.5,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Text('KEYWORDS'),
                ),
                Text(widget.post?.data()['keyWords']),
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Text('RESUME'),
                ),
                Text(widget.post?.data()['resume']),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomContentButton() {
    return Container(
      child: Column(
        children: [
          RaisedButton(
            onPressed: () =>
                Utils().pushScreen(context, EditOrder(post: widget.post)),
            color: Color.fromRGBO(58, 66, 86, 1.0),
            child: Text("SEE AND EDIT ORDER",
                style: TextStyle(color: Colors.white)),
          ),
          RaisedButton(
            child: Text('Click'),
            onPressed: () async {
              // Get the extension of the report file set by the user
              String reportExtension = await _controller.model.reportExtension;
              // Get the report url depending of the meeting ID and report Ext
              String reportUrl = await _controller.model.getReportUrl(
                meetingID: widget.post.id,
                reportExtension: reportExtension,
              );
              // Setup filename
              DateTime date = DateTime.now();
              String filename =
                  'report_synthia_${date.toString()}.$reportExtension';

              DownloadFile download = DownloadFile();

              if (reportUrl == null) {
                print('The report is not available or a error occured !');
                return;
              }
              // First init the class [mandatory]
              await download.init();
              // Start downloading
              download.start(
                url: reportUrl,
                filename: filename,
              );
            },
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
          children: <Widget>[bottomContentButton(), bottomContentText()],
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
              child: Text(widget.post.data()["schedule"],
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
        Utils()
            .pushScreen(context, RspyCommunication(meetingID: widget.post.id));
      },
    );
  }
}
