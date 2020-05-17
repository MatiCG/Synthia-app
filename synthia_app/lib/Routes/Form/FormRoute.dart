import 'package:flutter/material.dart';
import '../../Form/meetingInformation.dart';
import '../../Models/Form.dart';

// Debug
import 'dart:developer';

class MyForm extends StatefulWidget {
	MyForm() : super();

	@override
	Form createState() => Form();
}

class Form extends State<MyForm> {
	// Globals
	int _current = 0;
	bool _error = false;
	MeetingData model = MeetingData();

	Step customStep(title, content, index, error) {
		return Step(
			title: Text(_current == index ? title : ''),
			content: content,
			isActive: _current > index ? true : false,
			state: error == true && index == _current ? StepState.error : _current == index ? StepState.editing : _current > 0 ? StepState.complete : StepState.disabled
		);
	}

	List<Step> getSteps(BuildContext context) {
		List<Step> _steps = [
			customStep('What\'s it about ?', MeetingBasicInfo(model), 0, _error),
			customStep('Who is participating ?', Text('lol'), 1, _error),
			customStep('Summary', Text(''), 2, _error)
		];
		return _steps;
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
						// log(model.getData().toString());
						if (model.getMeetingTitle() == null && model.getMeetingSubject() == null) {
							log('ERRORR');
							setState(() {
								_error = true;
							  _current = _current;
							});
						} else {
							log('NOT EROR');
							setState(() {
								_error = false;
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