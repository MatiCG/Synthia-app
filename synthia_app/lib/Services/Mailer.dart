import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'SecretLoader.dart';

class Mailer {
  final Future<Secret> apiKey = SecretLoader(secretPath: "secrets.json").load();

  Future<http.Response> sendMail(data) async{
    String body = json.encode(data);
    var url = 'https://example.com';

    var response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    return response;
  }
}
