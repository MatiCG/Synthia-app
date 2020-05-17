import 'package:flutter/material.dart';
import '../../Form/meetingInformation.dart';

class MyForm extends StatefulWidget {
  MyForm() : super();

  @override
  Form createState() => Form();
}

class Form extends State<MyForm> {
  int _current = 0;

  Step customStep(title, content, index) {
    return Step(
      title: Text(_current == index ? title : ''),
      content: content,
      isActive: _current > index ? true : false,
      state: _current == index ? StepState.editing : _current > 0 ? StepState.complete : StepState.disabled
    );
  }

  List<Step> getSteps(BuildContext context) {
    List<Step> _steps = [
      customStep('What\'s it about ?', FirstRoute(), 0),
      customStep('Who is participating ?', Text('lol'), 1),
      customStep('Summary', Text(''), 2)
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
            setState(() {
              _current < steps.length - 1 ? _current++ : _current = steps.length - 1;
            });
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