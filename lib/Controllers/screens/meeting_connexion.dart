import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Models/screens/meeting_connexion.dart';

class MeetingConnexionController {
  final State<StatefulWidget> parent;
  final Meeting meeting;
  final MeetingConnexionModel model = MeetingConnexionModel();
  late List<BluetoothService> services;

  MeetingConnexionController(this.parent, this.meeting) {
    model.steps
      ..add(SynthiaStep(
        'Initialisation du bluetooth',
        action: _initBLE,
        status: StepStatus.progress,
      ))
      ..add(SynthiaStep('Détection de synthia', action: _searchDevice))
      ..add(SynthiaStep('Connexion à synthia', action: _connectToDevice))
      ..add(SynthiaStep('Configuration terminée', action: _configuration));
  }

  /// Init BLE library and start scanning if the BLE is on
  Future<void> _initBLE() async {
    await Future.delayed(const Duration(seconds: 2));
    log('_initBLE called');
    final FlutterBlue manager = model.bleManager;

    final bool isAvailable = await manager.isAvailable;
    final bool isEnable = await manager.isOn;

    _update(() {
      if (isAvailable && isEnable) {
        model.nextStep();
      } else if (!isAvailable) {
        model.currentStep
            .setError("Le bluetooth n'est pas disponible sur cet appareil");
      } else {
        model.currentStep.setError('Veuillez activé le bluetooth');
      }
    });
  }

  /// Search for bluetooth devices and end when the synthiaHome is founded
  Future<void> _searchDevice() async {
    await Future.delayed(const Duration(seconds: 2));
    log('_searchDevice called');
    final FlutterBlue manager = model.bleManager;
    bool deviceFounded = false;

    // Disconnect the previous synthia-home connected if is exist
    final devices = await manager.connectedDevices;

    for (final device in devices) {
      if (device.name == 'synthia-home') {
        await device.disconnect();
        log('previous device disconnected');
      }
    }

    // Search for the new device
    await manager
        .startScan(timeout: const Duration(seconds: 30))
        .then((value) async {
      if (!deviceFounded) {
        _update(() => model.currentStep.setError(
            "Veuillez vérifier que l'appareil synthia est allumé. Il est actuellement indétectable."));
      }
      await manager.stopScan();
    });
    manager.scanResults.listen((results) async {
      for (final result in results) {
        if (result.device.name == 'synthia-home') {
          deviceFounded = true;
          model.synthiaHome = result.device;
          await manager.stopScan();
          log('device founded');
          _update(() => model.nextStep());
        }
      }
    });
  }

  Future<void> _connectToDevice() async {
    await Future.delayed(const Duration(seconds: 2));
    log('_connectToDevice called');
    if (model.synthiaHome == null) {
      _update(() => model.currentStep
          .setError("L'appareil synthia n'est pas disponible..."));
    }
    try {
      await model.synthiaHome!.connect(timeout: const Duration(minutes: 1));
      _update(() => model.nextStep());
      log('device connected');
    } on TimeoutException {
      log('Timeout when connect to the device');
      _update(() => model.currentStep.setError(
          "Une erreur c'est produite lors de la connnexion à l'appareil."));
    } on Exception {
      log('Timeout when connect to the device');
      _update(() => model.currentStep.setError(
          "Une erreur c'est produite lors de la connnexion à l'appareil."));
    } catch (error) {
      log('An error occured when connect to the new device');
      _update(() => model.currentStep.setError(
          "Une erreur c'est produite lors de la connnexion à l'appareil."));
    }
  }

  Future startMeeting() async {
    log('startMeeting called');
    for (final service in services) {
      final servChar = service.characteristics;

      for (final element in servChar) {
        element.write(
            Uint8List.fromList(utf8.encode('START ${meeting.document!.id}')));
      }
    }
    log('sended');
    _update(() => model.meetingStarted = true);
  }

  Future _configuration() async {
    await Future.delayed(const Duration(seconds: 2));
    log('_configuration called');
    services = await model.synthiaHome!.discoverServices();

    for (final service in services) {
      final servChar = service.characteristics;

      for (final element in servChar) {
        final message = Uint8List.fromList(utf8.encode('CONFIGURATION ENDED'));
        element.write(message, withoutResponse: true);
      }
    }
    _update(() => model.endOfSteps());
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
