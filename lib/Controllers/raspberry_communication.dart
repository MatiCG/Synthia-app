import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:synthiaapp/Models/raspberry_communication.dart';

class RspyCommunicationController {
  final RspyCommunicationModel model = RspyCommunicationModel();
  BleManager _bleManager = BleManager();
  final dynamic parent;
  ScanResult _device;

  RspyCommunicationController({this.parent});

  Future<void> sendData(String data) async {
    await _device.peripheral.discoverAllServicesAndCharacteristics();
    List<Service> services = await _device.peripheral.services();

    services.forEach((service) async {
      var servChars = await service.characteristics();
      servChars.forEach((serChar) async {
        await _device.peripheral.writeCharacteristic(service.uuid, serChar.uuid,
            Uint8List.fromList(utf8.encode(data)), false);
      });
    });
  }
  Future<bool> startConnect(ScanResult device) async {
    try {
      await device.peripheral.connect();
      _device = device;
      parent.setState(() {
        setBleState(BLE_STATE.CONNECTED);
      });
      return true;
    } catch (error) {
      print('Error => ' + error.toString());
      parent.setState(() {
        setBleState(BLE_STATE.ERROR);
      });
    }
    return false;
  }
  /// Start scanning for synthia devices
  void startScan() async {
    _bleManager.startPeripheralScan().listen((device) async {
      if (device != null && device.peripheral.name != null) {
        String name = device.peripheral.name;
        print('device: ' + name == null ? 'error' : name);
        if (name.contains('synthia') || name.contains('Synthia')) {
          await Future.delayed(Duration(seconds: 2));
          parent.setState(() {
            model.setBleState(BLE_STATE.FOUNDED);
          });
          await _bleManager.stopPeripheralScan();
          await Future.delayed(Duration(seconds: 2));
          if (await startConnect(device)) {
            await Future.delayed(Duration(seconds: 2));
            parent.setState(() {
              // Notify that the configuration of the BLE
              // (SCANNING/FOUNDED/CONNECTED) is done
              model.isBleSetup = true;
            });
          }
        }
      }
    });
  }

  /// Init BLE library and start scanning if the BLE is on
  void initBLE() {
    _bleManager.createClient().then((value) {
      _bleManager.observeBluetoothState().listen((state) {
        if (state == BluetoothState.POWERED_ON) {
          parent.setState(() {
            this.setBleState(BLE_STATE.SCANNING);
            model.isBleOn = true;
            startScan();
          });
        } else if (state == BluetoothState.POWERED_OFF) {
          parent.setState(() {
            model.isBleOn = false;
          });
        }
      });
    });
  }

  void setBleState(BLE_STATE state) {
    parent.setState(() {
      model.setBleState(state);
    });
  }

  String getBleAnim() {
    return model.bleAnim;
  }
}
