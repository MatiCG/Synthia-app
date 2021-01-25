import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:synthiaapp/Controllers/raspberry_communication.dart';
import 'package:synthiaapp/Models/raspberry_communication.dart';

class RspyCommunication extends StatefulWidget {
  RspyCommunication({this.meetingID}) : super();

  final String meetingID;
  _RspyCommunicationState createState() => _RspyCommunicationState();
}

class _RspyCommunicationState extends State<RspyCommunication> {
  RspyCommunicationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RspyCommunicationController(parent: this);
    _controller.initBLE();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _controller.model.bleConfig
          ? FlatButton(
              child: Text('Start Meeting'),
              onPressed: () => _controller.sendData(widget.meetingID),
            )
          : buildBLEConnectionState(_controller),
    );
  }
}

/// Build the section of the setup of the bluetooth
Widget buildBLEConnectionState(RspyCommunicationController _controller) {
  return !_controller.model.bleIsOn
      ? Center(
          child: Text(
            'Please enable the bluetooth !',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w200,
            ),
          ),
        )
      : Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Lottie.network(_controller.getLottieUrl()),
            ),
          ],
        );
}
