import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/chip.dart';

class DetailMeetingCompleted extends StatefulWidget {
  final DetailMeetingController controller;

  const DetailMeetingCompleted({
    required this.controller,
  }) : super();

  @override
  _DetailMeetingCompletedState createState() => _DetailMeetingCompletedState();
}

class _DetailMeetingCompletedState extends State<DetailMeetingCompleted> {
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
      body: SafeArea(
        child: Wrap(
          children: [
            meetingText(widget.controller.meeting.title, 30, 20.0, 0.0,
                bold: true),
            meetingHandleChips(),
            meetingText('Voici votre compte-rendu:', 16, 20.0, 15.0,
                bold: true),
            Align(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.controller.meeting.resume,
                  textAlign: TextAlign.justify,
                  style: _textStyle(12, false),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Align(
        alignment: Alignment.bottomCenter,
        child: SynthiaButton(
          text: 'Télécharger',
          color: Theme.of(context).accentColor,
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            widget.controller.createPDF(widget.controller.meeting.resume,
                widget.controller.meeting.title);
          },
        ),
      ),
    );
  }

  Widget meetingHandleChips() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            SynthiaChip(
              text: 'Terminée',
            ),
            SynthiaChip(
              text: 'Compte-rendu envoyé par email',
              display: false,
            ),
          ],
        ));
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
