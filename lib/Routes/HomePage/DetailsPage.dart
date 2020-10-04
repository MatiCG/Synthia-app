import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Routes/HomePage/EditOrder.dart';
import 'package:synthiaapp/Widgets/DownloadFile.dart';
import '../../Services/Mailer.dart';
import '../../auth.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final auth = new Auth();
  var firestore = Firestore.instance;

  Future<void> sendSynthesis(values, Set<int> selectedValues) async {
    Mailer mailer = new Mailer();
    String user = await auth.currentUserMail();

    for (int i = 0; i < selectedValues.length; i++) {
      int selected = selectedValues.elementAt(i);
      Map<String, dynamic> toJson() => {
            "from": {
              'email': "synthia@no-reply.com",
            },
            "personalizations": [
              {
                "to": [
                  {"email": values[selected]}
                ],
                "dynamic_template_data": {
                  "email": user,
                  "title": widget.post.data["title"]
                }
              }
            ],
            "template_id": "d-bdca15e6acdd40b988f665d7c3bf1c59"
          };
      await mailer.sendMail(toJson());
    }
  }

  emailPopUp(BuildContext context) {
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
                onPressed: () {
                  firestore
                      .collection("meetings")
                      .where('title', isEqualTo: widget.post.data['title'])
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
                },
              )
            ],
          );
        });
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
            onPressed: () => navigateToEditOrder(widget.post),
            color: Color.fromRGBO(58, 66, 86, 1.0),
            child:
            Text("SEE AND EDIT ORDER", style: TextStyle(color: Colors.white)),
          ),
          Download(
            fileUrl: 'https://www.hq.nasa.gov/alsj/a17/A17_FlightPlan.pdf',
            fileExtension: 'pdf',
          )
        ],
      ),
    );
/*
    return Container(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: RaisedButton(
              onPressed: () => navigateToEditOrder(widget.post),
              color: Color.fromRGBO(58, 66, 86, 1.0),
              child:
              Text("SEE AND EDIT ORDER", style: TextStyle(color: Colors.white)),
            )),
    );
*/
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

  navigateToEditOrder(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditOrder(
                  post: post,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[topContent(), bottomContent()],
      ),
    );
  }
}
