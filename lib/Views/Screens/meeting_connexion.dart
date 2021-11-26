import 'dart:async';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Controllers/screens/meeting_connexion.dart';
import 'package:synthiapp/Classes/meeting.dart';

class MeetingConnexion extends StatefulWidget {
  final Meeting meeting;

  const MeetingConnexion({required this.meeting}) : super();

  @override
  _MeetingConnexionState createState() => _MeetingConnexionState();
}

class _MeetingConnexionState extends State<MeetingConnexion> {
  MeetingConnexionController? _controller;
  final RecorderStream _recorder = RecorderStream();

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  late StreamSubscription<List<int>> _audioStreamSubscription;
  late BehaviorSubject<List<int>> _audioStream;

  @override
  void initState() {
    super.initState();

    _controller = MeetingConnexionController(this, widget.meeting);
    _recorder.initialize();
  }

  void streamingRecognize() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream.add(event);
    });

    await _recorder.start();

    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream);

    var responseText = '';

    responseStream.listen((data) {
      final currentText =
          data.results.map((e) => e.alternatives.first.transcript).join('\n');

      if (data.results.first.isFinal) {
        responseText += '\n' + currentText;
        setState(() {
          text = responseText;
          recognizeFinished = true;
        });
      } else {
        setState(() {
          text = responseText + '\n' + currentText;
          recognizeFinished = true;
        });
      }
    }, onDone: () {
      setState(() {
        recognizing = false;
      });
    });
  }

  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription.cancel();
    await _audioStream.close();
    setState(() {
      recognizing = false;
    });
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'fr-FR');

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Stream Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (recognizeFinished)
              _RecognizeContent(
                text: text,
              ),
            ElevatedButton(
              onPressed: recognizing ? stopRecording : streamingRecognize,
              child: recognizing ? Text('Stop') : Text('Start'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _RecognizeContent extends StatelessWidget {
  final String text;

  const _RecognizeContent({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'The text recognized by the Google Speech Api:',
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
