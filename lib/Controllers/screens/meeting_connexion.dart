import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Models/screens/meeting_connexion.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:synthiapp/config/config.dart';
import 'package:http/http.dart' as http;

class MeetingConnexionController {
  final State<StatefulWidget> parent;
  final Meeting meeting;
  final MeetingConnexionModel model = MeetingConnexionModel();
  final RecorderStream _recorder = RecorderStream();

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  late StreamSubscription<List<int>> _audioStreamSubscription;
  late BehaviorSubject<List<int>> _audioStream;

  MeetingConnexionController(this.parent, this.meeting) {
    _recorder.initialize();
  }

  // ignore: avoid_void_async
  void streamingRecognize() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream.add(event);
    });

    await _recorder.start();

    utils.updateView(parent, update: () {
      recognizing = true;
    });

    final serviceAccount = ServiceAccount.fromString(
        await rootBundle.loadString('assets/test_service_account.json'));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream);

    var responseText = text;

    responseStream.listen((data) {
      final currentText =
          data.results.map((e) => e.alternatives.first.transcript).join('\n');

      if (data.results.first.isFinal) {
        responseText += '\n$currentText';
        utils.updateView(parent, update: () {
          text = responseText;
          recognizeFinished = true;
        });
      } else {
        utils.updateView(parent, update: () {
          text = '$responseText\n$currentText';
          recognizeFinished = true;
        });
      }
    }, onDone: () {
      utils.updateView(parent, update: () {
        recognizing = false;
      });
    });
  }

  // ignore: avoid_void_async
  void pushMeeting() async {
    String token = '';

    FirebaseFirestore.instance
        .collection('meetings')
        .doc(meeting.document!.id)
        .update({'rawText': text});
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        final Map<String, dynamic> data =
            snapshot.data()! as Map<String, dynamic>;
        token = data["token"].toString();
        print("-----------------------------------" + token);
        final client = new http.Client();
        try {
          await client.get(Uri.parse(
              'https://40.89.182.198:6000/${meeting.document!.id}/fr/$token'));
        } catch (e) {
          print(e);
        } finally {
          client.close();
        }
      }
    });
  }

  // ignore: avoid_void_async
  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription.cancel();
    await _audioStream.close();
    utils.updateView(parent, update: () {
      recognizing = false;
    });
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'fr-FR');
}
