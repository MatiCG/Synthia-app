
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class TestPage extends StatefulWidget {
  TestPage() : super();

  @override
  Test createState() => Test();
}

class Test extends State<TestPage> {
 @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            onPressed: _send,
            child: const Text('Send Test Email', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  Future<void> _send() async {
    final Email email = Email(
      body: 'test',
      subject: 'test 1212',
      recipients: ['matias.castro-guzman@epitech.eu'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
  }
}