import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'SecretLoader.dart';
import 'dart:developer';

class Mailer {

  Future<http.Response> sendMail(data) async{
    String body = json.encode(data);
    Secret apiKey = await SecretLoader(secretPath: "secrets.json").load();
    var url = 'https://api.sendgrid.com/v3/mail/send';

    var response = await http.post(url,
      headers: {
        "Authorization": "Bearer " + apiKey.apiKey.toString(),
        "Content-Type": "application/json"},
      body: body,
    );
    return response;
  }
}
