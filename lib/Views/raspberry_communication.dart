import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:lottie/lottie.dart';

class RspyCommunication extends StatefulWidget {
  RspyCommunication() : super();

  _RspyCommunication createState() => _RspyCommunication();
}

class _RspyCommunication extends State<RspyCommunication> {
  BleManager bleManager = BleManager();
  bool isScanning = true;
  bool isOn = false;
  bool isFounded = false;
  bool isConnected = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    bleManager.createClient().then((value) {
      bleManager.observeBluetoothState().listen((event) {
        if (event == BluetoothState.POWERED_ON) {
          setState(() {
            isOn = true;
          });
        } else if (event == BluetoothState.POWERED_OFF) {
          setState(() {
            isOn = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isOn
          ? isScanning
              ? buildRaspberrySearch()
              : null // display device,
          : Center(
              child: Text(
                'Please enable the bluetooth !',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
    );
  }

/*
  Widget buildRaspberryFound() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          ,
        )
      ],
    );
  }
*/
  void startSearch() {
    bleManager.startPeripheralScan().listen((scanResult) async {
      if (scanResult.peripheral.name != null &&
          scanResult.peripheral.name.contains('WH')) {
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          isFounded = true;
        });
        print('Founded');
        await scanResult.peripheral.connect();
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          isConnected = true;
        });
//        scanResult.peripheral.writeCharacteristic(serviceUuid, characteristicUuid, value, withResponse)
      }
    });
  }

  Widget buildConnectedDevice() {
    return Column(
      children: [
        Text(
          'Device Connected',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),
        RaisedButton(
          child: Text('Start meeting'),
          onPressed: null,
        ),
      ],
    );
  }

  Widget buildRaspberrySearch() {
    startSearch();
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Lottie.network(
            !isFounded
                ? 'https://assets2.lottiefiles.com/packages/lf20_W8gUO8.json'
                : !isConnected
                    ? 'https://assets5.lottiefiles.com/packages/lf20_ndlvehgz.json'
                    : 'https://assets3.lottiefiles.com/datafiles/Wv6eeBslW1APprw/data.json',
            controller: _controller,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              !isFounded
                  ? 'Searching for your Synthia-Home...'
                  : !isConnected
                      ? 'Synthia-Home founded ! Connecting...'
                      : 'Connected to the Synthia-Home',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        )
      ],
    );
  }
}
