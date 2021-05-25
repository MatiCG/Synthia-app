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
                meetingText(this._controller!.model.title, 30, 30.0, 0.0, true),
                meetingDate(),
                meetingText(
                    this._controller!.model.description, 12, 30.0, 40.0, false),
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
                meetingText(this._controller!.model.title, 30, 30.0, 0.0, true),
                meetingHandleChips(),
                meetingText("Voici Votre compte-rendu :", 17, 30.0, 40.0, true),
                meetingText(
                    this._controller!.model.resume, 10, 30.0, 0.0, false),
              ],
            ),
          ),
          bottomSheet: meetingButton("Télécharger", () => print("Télécharger")),
        );
    }
  }

  Widget meetingDate() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
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

  Widget meetingText(
      String text, double size, double padH, double padV, bool bold) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        child: Text(
          text,
          style: _textStyle(size, bold),
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

  Widget meetingHandleChips() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            meetingChip("Terminée", this._controller!.isMeetingComplete()),
            meetingChip("CR envoyé par mail", true)
          ],
        ));
  }

  Widget meetingChip(String text, bool shouldDisplay) {
    if (shouldDisplay)
      return Chip(
        label: Text(text,
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.green,
        avatar: CircleAvatar(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
        ),
      );
    else
      return SizedBox.shrink();
  }

  TextStyle _textStyle(double fontSize, bool bold) {
    return TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
}
