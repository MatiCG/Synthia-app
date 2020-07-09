import 'package:flutter/material.dart';
import 'package:synthiaapp/Models/FormModel.dart';

class MeetingSummary extends StatefulWidget {
	final MeetingData model;
	MeetingSummary([this.model]);

	@override
	Summary createState() => Summary();
}

class Summary extends State<MeetingSummary> {
  @override
	Widget build(BuildContext context) {
    return Card(
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(children: <Widget>[
          Text(widget.model.getMeetingTitle()),
          Text(widget.model.getMeetingSubject()),
          Text(widget.model.getMeetingSchedule()),
          Text('list of members'),
        ],),
      ),
    );
  }
}