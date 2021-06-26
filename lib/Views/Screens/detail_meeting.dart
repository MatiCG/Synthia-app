import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/Views/details_meeting/meeting_completed.dart';
import 'package:synthiapp/Views/details_meeting/meeting_in_progress.dart';

class DetailMeetingPage extends StatefulWidget {
  final Meeting meeting;

  const DetailMeetingPage({required this.meeting}) : super();

  @override
  _DetailMeetingPageState createState() => _DetailMeetingPageState();
}

class _DetailMeetingPageState extends State<DetailMeetingPage> {
  late DetailMeetingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = DetailMeetingController(
      parent: this,
      meeting: widget.meeting,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          SynthiaFirebase().fetchReportResumeStream(widget.meeting.document),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final PageStatus status = _controller.getPageStatus(snapshot.data!);
          if (status == PageStatus.progress) {
            return DetailMeetingProgress(
              controller: _controller,
            );
          } else {
            return DetailMeetingCompleted(
              controller: _controller,
              resume: _controller.getResumeFromSnapshot(snapshot.data!),
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
/*
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synthiapp/Animations/screen_transition.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Views/Screens/meeting_connexion.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/config/config.dart';

class DetailMeetingPage extends StatefulWidget {
  final String _meetingId;

  const DetailMeetingPage(this._meetingId) : super();

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
    if (_controller == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )),
      );
    } else {
      if (_controller!.isMeetingComplete() == false) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )),
          body: SafeArea(
            child: Wrap(
              children: [
                meetingText(_controller!.model.title, 30, 30.0, 0.0, bold: true),
                meetingDate(),
                meetingText(
                    _controller!.model.description, 12, 30.0, 40.0, bold: false),
              ],
            ),
          ),
          bottomSheet: meetingButton("Commencer", () {
            utils.pushScreenTransition(
                context, const MeetingConnexion(), Transitions.upToDown);
          }),
        );
      } else {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )),
          body: SafeArea(
            child: Wrap(
              children: [
                meetingText(_controller!.model.title, 30, 30.0, 0.0, bold: true),
                meetingHandleChips(),
                meetingText("Voici Votre compte-rendu :", 17, 30.0, 40.0, bold: true),
                meetingText(_controller!.model.resume, 10, 30.0, 0.0, bold: false),
              ],
            ),
          ),
          bottomSheet: meetingButton("Télécharger", () => log("Télécharger")),
        );
      }
    }
  }

  Widget meetingDate() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Wrap(children: [
          const Icon(Icons.access_time, color: Colors.black, size: 12.0),
          Text(
            DateFormat.yMMMd('en_US')
                .add_jm()
                .format(_controller!.model.date.toDate()),
            style: _textStyle(12, false),
          ),
        ]));
  }

  // ignore: avoid_positional_boolean_parameters
  Widget meetingText(String text, double size, double padH, double padV,
      {required bool bold}) {
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            meetingChip("Terminée",
                shouldDisplay: _controller!.isMeetingComplete()),
            meetingChip("CR envoyé par mail", shouldDisplay: true)
          ],
        ));
  }

  Widget meetingChip(String text, {required bool shouldDisplay}) {
    if (shouldDisplay) {
      return Chip(
        label: Text(text,
            style: const TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.green,
        avatar: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      );
    }
    else {
      return const SizedBox.shrink();
    }
  }

  TextStyle _textStyle(double fontSize, bool bold) {
    return TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
}
*/