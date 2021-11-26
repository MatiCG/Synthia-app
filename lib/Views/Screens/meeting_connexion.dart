import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/meeting_connexion.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Widgets/app_bar.dart';

class MeetingConnexion extends StatefulWidget {
  final Meeting meeting;

  const MeetingConnexion({required this.meeting}) : super();

  @override
  _MeetingConnexionState createState() => _MeetingConnexionState();
}

class _MeetingConnexionState extends State<MeetingConnexion> {
  MeetingConnexionController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = MeetingConnexionController(this, widget.meeting);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return const Scaffold();

    return Scaffold(
      appBar: const SynthiaAppBar(
        title: '',
        closeIcon: Icons.close,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (_controller!.recognizeFinished)
              _RecognizeContent(
                text: _controller!.text,
              ),
            if (_controller!.recognizeFinished && !_controller!.recognizing)
              ElevatedButton(
                onPressed: () => {}, //add call to api and push text <<<<<<<<<<
                child: Text('End Meeting'),
              ),
            ElevatedButton(
              onPressed: _controller!.recognizing
                  ? _controller!.stopRecording
                  : _controller!.streamingRecognize,
              child: _controller!.recognizing ? Text('Stop') : Text('Start'),
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
            'Text Recognized :',
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
