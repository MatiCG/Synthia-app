import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/meeting_connexion.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Widgets/app_bar.dart';
import 'package:synthiapp/Widgets/button.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              _controller!.meeting.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (_controller!.recognizeFinished)
            _RecognizeContent(
              text: _controller!.text,
            ),
          const Expanded(
            child: Text(""),
          ),
          if (_controller!.recognizeFinished && !_controller!.recognizing)
            Align(
              alignment: Alignment.bottomCenter,
              child: SynthiaButton(
                text: "Terminer la réunion",
                color: const Color(0xFF00C627),
                textColor: Theme.of(context).primaryColor,
                onPressed: () => {}, //add call to api and push text <<<<<<<<<<
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SynthiaButton(
                text: _controller!.recognizing ? 'Suspendre' : 'Enregistrer',
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                onPressed: _controller!.recognizing
                    ? _controller!.stopRecording
                    : _controller!.streamingRecognize),
          ),
        ],
      ),
    );
  }
}

class _RecognizeContent extends StatelessWidget {
  final String text;

  const _RecognizeContent({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child:
                Text('Text reconnu :', style: _textStyled(context, size: 20)),
          ),
          Text(
            text,
            textAlign: TextAlign.justify,
          )
        ]),
      ]),
    );
  }

  TextStyle _textStyled(BuildContext context, {double size = 14}) {
    return TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.w400,
        fontSize: size);
  }
}
