import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Controllers/screens/meeting_connexion.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/Models/screens/meeting_connexion.dart';
import 'package:synthiapp/Widgets/app_bar.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/config/config.dart';

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
    SynthiaFirebase()
        .fetchReportResumeStream(widget.meeting.document!)
        .listen((event) {
      if (_controller!.model.meetingStarted) {
        if (SynthiaFirebase().checkSnapshotDocument(event, keys: ['resume'])) {
          if ((event.data()!['resume'] as String).isNotEmpty) {
            Navigator.pop(context);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return const Scaffold();
    final steps = _controller!.model.steps;

    return Scaffold(
      appBar: const SynthiaAppBar(
        title: '',
        closeIcon: Icons.close,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          if (_controller!.model.meetingStarted)
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Enregistrement de la réunion en cours ....',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          if (!_controller!.model.meetingStarted)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: steps.length,
              itemBuilder: (context, index) {
                if (index == 0 && !_controller!.model.bleInitiated) {
                  steps[index].action!();
                  _controller!.model.bleInitiated = true;
                }
                return StepText(
                    title: steps[index].title, status: steps[index].status);
              },
            ),
          Flexible(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                _controller!.model.currentStep.errorMessage ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          if (_controller!.model.currentStep.onError)
            SynthiaButton(
              text: 'Recommencer',
              textColor: Theme.of(context).primaryColor,
              color: Colors.red,
              onPressed: () {
                _controller!.model.bleInitiated = false;
                utils.pushReplacementScreen(
                    context, MeetingConnexion(meeting: widget.meeting));
              },
            ),
          if (!_controller!.model.currentStep.onError &&
              !_controller!.model.meetingStarted)
            SynthiaButton(
              text: 'Commencer',
              textColor: Theme.of(context).primaryColor,
              color: Theme.of(context).accentColor,
              enable: _controller?.model.configurationEnded ?? false,
              onPressed: () => _controller!.startMeeting(),
            ),
        ],
      ),
    );
  }
}

class StepText extends StatelessWidget {
  final String title;
  final StepStatus status;

  const StepText({required this.title, required this.status}) : super();

  @override
  Widget build(BuildContext context) {
    final Color color = status == StepStatus.stack
        ? Colors.grey.shade500
        : status == StepStatus.done
            ? Colors.green
            : status == StepStatus.error
                ? Colors.red
                : Colors.black;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: status == StepStatus.done
          ? const Icon(Icons.check_circle_outlined, color: Colors.green)
          : status == StepStatus.error
              ? const Icon(Icons.error, color: Colors.red)
              : status == StepStatus.progress
                  ? const CircularProgressIndicator()
                  : null,
    );
  }
}
