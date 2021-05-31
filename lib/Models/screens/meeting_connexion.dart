//import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:flutter_blue/flutter_blue.dart';

enum StepStatus {
  progress,
  done,
  error,
  stack,
}

class SynthiaStep {
  String title;
  final Function? action;
  StepStatus status;
  String? errorMessage;
  bool onError = false;

  SynthiaStep(this.title, {this.action, this.status = StepStatus.stack});

  set setError(String? message) {
    this.status = StepStatus.error;
    if (message != null)
      this.errorMessage = message;
    this.onError = true;
  }
}

class MeetingConnexionModel {
  final FlutterBlue bleManager = FlutterBlue.instance;
  List<SynthiaStep> steps = [];
  int stepIndex = 0;

  void nextStep() {
    steps[stepIndex].status = StepStatus.done;
    stepIndex++;
  }

  SynthiaStep get currentStep => steps[stepIndex];
}
