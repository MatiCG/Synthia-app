import 'package:flutter/material.dart';
import '../../Form/meetingInformation.dart';
import '../../Form/meetingSummary.dart';
import '../../Models/FormModel.dart';
import '../../Form/meetingListMembers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyForm extends StatefulWidget {
	MyForm() : super();

	@override
	Form createState() => Form();
}

class Form extends State<MyForm> {
	int _current = 0;
	bool _error = false;
	MeetingData model = MeetingData();
	final databaseReference = Firestore.instance;

	Step customStep(title, content, index, error) {
		return Step(
			title: Text(_current == index ? title : ''),
			content: content,
			isActive: _current > index ? true : false,
			state: error == true && index == _current ? StepState.error : _current == index ? StepState.editing : _current > index ? StepState.complete : StepState.disabled
		);
	}

	List<Step> getSteps(BuildContext context) {
		List<Step> _steps = [
			customStep('What\'s it about ?', MeetingBasicInfo(model), 0, _error),
			customStep('Who is participating ?', MeetingMembers(model), 1, _error),
			customStep('Summary', MeetingSummary(model), 2, _error)
		];
		return _steps;
	}

	void pushDataMeeting() async {
		await databaseReference.collection('meetings')
				.document(model.getMeetingId())
				.setData(model.getData());
	}

	@override
	Widget build(BuildContext context) {
		List<Step> steps = getSteps(context);
		return Scaffold (
			appBar: AppBar(title: Text('Create your meeting')),
			body: Container(
				padding: EdgeInsets.all(20.0),
				child: Stepper(
					type: StepperType.horizontal,
					steps: steps,
					currentStep: _current,
					onStepContinue: () {
						print(model.getData().toString());
						if (model.verify(_current)== false) {
							setState(() {
								_error = true;
							  _current = _current;
							});
						} else {
							setState(() {
								_error = false;
								if (_current >= steps.length - 1) {
									pushDataMeeting();
									Navigator.pop(context);
								}
								_current < steps.length - 1 ? _current++ : _current = steps.length - 1;
							});
						}
					},
					onStepCancel: () {
						setState(() {
							_current > 0 ? _current-- : _current = 0;
						});
					},
					onStepTapped: (index) {
						setState(() {
							_current = index;
						});
					},
				),
			),
		);
	}
}