import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';
import 'package:synthiapp/Views/Screens/meeting_connexion.dart';
import 'package:synthiapp/Views/creation_meeting/handle_members.dart';
import 'package:synthiapp/Widgets/add_members.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/list_members.dart';
import 'package:synthiapp/config/config.dart';

class DetailMeetingProgress extends StatefulWidget {
  final DetailMeetingController controller;

  const DetailMeetingProgress({
    required this.controller,
  }) : super();

  @override
  _DetailMeetingProgressState createState() => _DetailMeetingProgressState();
}

class _DetailMeetingProgressState extends State<DetailMeetingProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          )),
      body: Column(
        children: [
          Wrap(
            children: [
              meetingText(widget.controller.meeting.title, 30, 20.0, 0.0,
                  bold: true),
              meetingDate(),
              meetingText(widget.controller.meeting.description, 14, 20.0, 20.0,
                  bold: false),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 64, bottom: 16),
                    child: Text(
                      'Ajouter de nouveaux participants',
                      style: TextStyle(
                        color: Color(0xff8F8F8F),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: AddMembers(
                      members: widget.controller.meeting.members,
                      onTrailingPress: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: ListMembers(
                                members: widget.controller.meeting.members,
                              ),
                            );
                          },
                        );
                        _update();
                      },
                      onLeadingPress: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: HandleMembers(
                                meeting: widget.controller.meeting,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(child: Container()),
          Align(
            alignment: Alignment.bottomCenter,
            child: SynthiaButton(
              text: 'Commencer',
              enable: widget.controller.isTodaysDate(),
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              onPressed: () => utils.pushScreen(context, MeetingConnexion(meeting: widget.controller.meeting,)),
            ),
          ),
        ],
      ),
    );
  }

  void _update() {
    setState(() {});
    FirebaseFirestore.instance
        .doc(widget.controller.meeting.document.path)
        .update({
      'members': widget.controller.meeting.members,
    });
  }

  Widget meetingDate() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15.0),
        child: Row(children: [
          const Icon(Icons.access_time, color: Colors.black, size: 12.0),
          Text(
            DateFormat.yMMMd('en_US')
                .add_jm()
                .format(widget.controller.meeting.date.toDate()),
            style: _textStyle(12, false),
          ),
        ]));
  }

  Widget meetingText(String text, double size, double padH, double padV,
      {required bool bold}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        child: Text(
          text,
          style: _textStyle(size, bold),
        ));
  }

  TextStyle _textStyle(double fontSize, bool bold) {
    return TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
}
