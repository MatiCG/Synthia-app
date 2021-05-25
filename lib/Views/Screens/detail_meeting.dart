import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Widgets/button.dart';

class DetailMeetingPage extends StatefulWidget {
  final String _meetingId;

  DetailMeetingPage(this._meetingId) : super();

  @override
  _DetailMeetingPageState createState() => _DetailMeetingPageState();
}

class _DetailMeetingPageState extends State<DetailMeetingPage> {
  DetailMeetingController? _controller;

  @override
  void initState() {
    super.initState();

    setState(() {
      _controller = DetailMeetingController(this, widget._meetingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null)
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )),
      );
    else {
      if (this._controller!.isMeetingComplete() == false)
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )),
          body: SafeArea(
            child: Wrap(
              children: [
                meetingTitle(),
                meetingDate(),
                meetingDescription(),
              ],
            ),
          ),
          bottomSheet: meetingButton("Commencer", () => print("start")),
        );
      else
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )),
          body: SafeArea(
            child: Wrap(
              children: [
                meetingTitle(),
              ],
            ),
          ),
          bottomSheet: meetingButton("Télécharger", () => print("Télécharger")),
        );
    }
  }

  Widget meetingTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Text(
        this._controller!.model.title,
        style: _textStyle(30, true),
      ),
    );
  }

  Widget meetingDate() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Wrap(children: [
          Icon(Icons.access_time, color: Colors.black, size: 12.0),
          Text(
            DateFormat.yMMMd('en_US')
                .add_jm()
                .format(this._controller!.model.date.toDate()),
            style: _textStyle(12, false),
          ),
        ]));
  }

  Widget meetingDescription() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
        child: Text(
          this._controller!.model.description,
          style: _textStyle(12, false),
        ));
  }

  Widget meetingButton(String buttonText, Function buttonPressed) {
    return Center(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SynthiaButton(
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                text: buttonText,
                onPressed: buttonPressed,
              ),
            )));
  }

  TextStyle _textStyle(double fontSize, bool bold) {
    return TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
}
