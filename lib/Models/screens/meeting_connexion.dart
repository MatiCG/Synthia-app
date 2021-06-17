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

  void setError(String? message) {
    status = StepStatus.error;
    if (message != null) errorMessage = message;
    onError = true;
  }
}

class MeetingConnexionModel {
  final FlutterBlue bleManager = FlutterBlue.instance;
  BluetoothDevice? synthiaHome;
  List<SynthiaStep> steps = [];
  int stepIndex = 0;

  void nextStep() {
    steps[stepIndex].status = StepStatus.done;
    stepIndex++;
    if (stepIndex + 1 <= steps.length) {
      steps[stepIndex].status = StepStatus.progress;
      if (steps[stepIndex].action != null) steps[stepIndex].action!();
    }
  }

  SynthiaStep get currentStep => steps[stepIndex];
}