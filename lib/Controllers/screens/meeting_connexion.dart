import 'dart:convert' show utf8;
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:synthiapp/Models/screens/meeting_connexion.dart';
import 'package:synthiapp/config/config.dart';

class MeetingConnexionController {
  final State<StatefulWidget> parent;
  final MeetingConnexionModel model = MeetingConnexionModel();

  MeetingConnexionController(this.parent) {
    model.steps
      ..add(SynthiaStep(
        'Initialisation du bluetooth',
        action: _initBLE,
        status: StepStatus.progress,
      ))
      ..add(SynthiaStep('Détection de synthia', action: _searchDevice))
      ..add(SynthiaStep('Connexion à synthia', action: _connectToDevice))
      ..add(SynthiaStep('Configuration terminée', action: _communicationTest));
  }

  /// Search for bluetooth devices and end when the synthiaHome is founded
  void _searchDevice() {
    log('_searchDevice called');
    final FlutterBlue manager = model.bleManager;
    bool deviceFounded = false;

    Future.delayed(const Duration(seconds: 2)).then((value) {
      manager.startScan(timeout: const Duration(seconds: 30)).then((value) {
        if (!deviceFounded) {
          _update(() => model.currentStep.setError(
              "Veuillez vérifier que l'appareil synthia est allumé. Il est actuellement indétectable."));
        }
        manager.stopScan();
      });

      manager.scanResults.listen((results) {
        for (final result in results) {
          if (result.device.name == 'synthia-home') {
            deviceFounded = true;
            model.synthiaHome = result.device;
            manager.stopScan();
            _update(() => model.nextStep());
          }
        }
      });
    });
  }

  /// Init BLE library and start scanning if the BLE is on
  void _initBLE() {
    log('_initBLE called');
    final FlutterBlue manager = model.bleManager;
    Future.delayed(const Duration(seconds: 2)).then((value) {
      manager.isAvailable.then((value) {
        if (value) {
          manager.isOn.then((value) {
            _update(() {
              if (value) {
                model.nextStep();
              } else {
                model.currentStep.setError('Veuillez activé le bluetooth');
                manager.stopScan();
              }
            });
          });
        } else {
          _update(() => model.currentStep
              .setError("Le bluetooth n'est pas disponible sur cet appareil"));
          manager.stopScan();
        }
      });
    });
  }

  void _connectToDevice() {
    log('_connectToDevice called');
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (model.synthiaHome == null) {
        utils.updateView(parent, update: () {
          model.currentStep.setError("L'appareil synthia n'est pas disponible...");
        });
      }
      try {
        model.synthiaHome!.connect();
        log('Connected');
        _update(() => model.nextStep());
      } catch (err) {
        log('err: $err');
        _update(() => model.currentStep.setError("Une erreur c'est produite lors de la connnexion à l'appareil. "));
      }
    });
  }

  Future _communicationTest() async {
    log('_communicationTest called');
    await Future.delayed(const Duration(seconds: 2)).then((value) async {
      final services = await model.synthiaHome!.discoverServices();

      for (final service in services) {
        final servChar = service.characteristics;

        for (final element in servChar) {
          element.write(Uint8List.fromList(
              utf8.encode('Hello World from new synthia APP')));
        }
      }
    });
  }

  void _update(Function function) {
    if (parent.mounted) {
      // ignore: invalid_use_of_protected_member
      parent.setState(() {
        function();
      });
    }
  }
}
