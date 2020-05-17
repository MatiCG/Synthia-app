import 'package:flutter/material.dart';
import 'package:synthiaapp/Models/FormModel.dart';

class MeetingMembers extends StatefulWidget {
	final MeetingData model;
	MeetingMembers([this.model]);

	@override
	Members createState() => Members();
}

class Members extends State<MeetingMembers> {
	final _inputemail = TextEditingController();

	@override
  void dispose() {
    _inputemail.dispose();
    super.dispose();
  }

	@override
	Widget build(BuildContext context) {
		return Material(
			child: Container (
				child: Column(
					children: <Widget>[
						TextField(
							keyboardType: TextInputType.emailAddress,
							controller: _inputemail,
							decoration: InputDecoration(
								hintText: "Enter member email",
								suffixIcon: IconButton(
									onPressed: () {
										setState(() {
											widget.model.addMemberMeetingMembers(_inputemail.text);
//											_list.add(_inputemail.text);
											_inputemail.clear();
										});
									},
									icon: Icon(Icons.person_add),
								),
							),
						),
						Container(
							height: 250,
							child: ListView.builder(
								shrinkWrap: true,
								padding: const EdgeInsets.all(20.0),
								itemCount: widget.model.getMeetingMembers().length,
			          itemBuilder: (context, index) => Text(widget.model.getMeetingMembers()[index]),
							),
						),
					],
				)
			)
		);
	}
}

/*
					TextField(
						decoration: InputDecoration(
							hintText: "Enter member email",
							suffixIcon: IconButton(
								onPressed: () => print('lol'),
								icon: Icon(Icons.person_add),
							),
						),
					),

*/