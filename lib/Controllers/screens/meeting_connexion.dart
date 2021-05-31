import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:synthiapp/Models/screens/meeting_connexion.dart';

class MeetingConnexionController {
  final State<StatefulWidget> parent;
  final MeetingConnexionModel model = MeetingConnexionModel();

  MeetingConnexionController(this.parent) {
    model.steps
      ..add(SynthiaStep(
        'Initialisation du bluetooth',
        action: _initBLE(),
        status: StepStatus.progress,
      ))
      ..add(SynthiaStep('Détection de synthia', action: _searchDevice()))
      ..add(SynthiaStep('Connexion à synthia', action: _detection()))
      ..add(SynthiaStep('Configuration terminée', action: _detection()));
  }

  /// Search for bluetooth devices and end when the synthiaHome is founded
  _searchDevice() {
    final FlutterBlue manager = model.bleManager;

    manager.startScan(timeout: Duration(seconds: 60));

    manager.scanResults.listen((results) {
      for (var result in results) {
        print('Device founded: ${result.device.name}');
      }
    });
  }

  /// Init BLE library and start scanning if the BLE is on
  _initBLE() {
    final FlutterBlue manager = model.bleManager;
    Future.delayed(Duration(seconds: 2)).then((value) {
      manager.isAvailable.then((value) {
        if (value) {
          manager.isOn.then((value) {
            _update(() {
              if (value) {
                model.nextStep();
              } else {
                model.currentStep.setError = 'Veuillez activé le bluetooth';
              }
            });
          });
        } else {
          _update(() => model.currentStep.setError =
            'Le bluetooth n\'est pas disponible sur cet appareil');
        }
      });
    });
  }

  _bluetooth() {}

  _detection() {}

  _update(Function function) {
    if (parent.mounted) {
      // ignore: invalid_use_of_protected_member
      parent.setState(() {
        function();
      });
    }
  }
}
