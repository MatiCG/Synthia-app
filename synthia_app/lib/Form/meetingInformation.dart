import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synthiaapp/Models/Form.dart';

class MeetingBasicInfo extends StatefulWidget {
	MeetingData model;
	MeetingBasicInfo([this.model]);

	@override
	Info createState() => Info();
}

class Info extends State<MeetingBasicInfo> {
	DateTime _date = DateTime.now();

	Future<Null> pickDate(BuildContext context) async {
		final DateTime picked = await showDatePicker(
			context: context,
			initialDate: _date,
			firstDate: DateTime(2020),
			lastDate: DateTime(2100),
		);

		if (picked != null && picked != _date) {
			setState(() {
			  _date = picked;
				widget.model.setMeetingSchedule(_date.toString());
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return Material(
			child: Container(
				child: Column(
					children: <Widget>[
						TextFormField(
							initialValue: widget.model.getMeetingTitle(),
							onChanged: (text) {
								widget.model.setMeetingTitle(text);
							},
							decoration: InputDecoration(
								border: OutlineInputBorder(),
								labelText: 'Meeting title'
							),
						),
						Container(
							child: TextFormField(
								initialValue: widget.model.getMeetingSubject(),
								onChanged: (text) {
									widget.model.setMeetingSubject(text);
								},
								decoration: InputDecoration(
									border: OutlineInputBorder(),
									labelText: 'What the subject of the meeting ?',
								),
							),
						),
						Container(
							child: Column(
								children: <Widget>[
									Text('Your meeting will start the ' + _date.day.toString() + '/' + _date.month.toString() + '/' + _date.year.toString()),
									FlatButton(
										onPressed: () {
											pickDate(context);
										},
										child: Text('Change meeting schedule.'),
									),
								],
							),
						)
					],
				),
			),
		);
	}
}