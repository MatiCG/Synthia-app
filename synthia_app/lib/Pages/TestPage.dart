
import 'dart:async';
import '../Services/Mailer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../Services/SecretLoader.dart';
class TestPage extends StatefulWidget {
  TestPage() : super();

  @override
  Test createState() => Test();
}


class Test extends State<TestPage> {

  Future<void> testSendGrid() async {
    Map<String, dynamic> toJson() =>
    {
      "from": {
        'email': "synthia@no-reply.com",
      },
      "personalizations": [{
        "to": [{
          "email": "matias.castro-guzman@epitech.eu"
        }],
        "dynamic_template_data": {
          "name": "Matias"
        },
        "subject": "Thanks for joining Synthia"
      }],
      "template_id": "d-f9371f5562984dcd8f2e21ca75423924"
    };

    Mailer mailer = new Mailer();
    var response = await mailer.sendMail(toJson());
    print(response.statusCode);
    print(response.body);
  }

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
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: testSendGrid,
            child: const Text('Send Confirmation', style: TextStyle(fontSize: 20)),
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