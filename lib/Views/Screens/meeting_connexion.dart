import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/meeting_connexion.dart';
import 'package:synthiapp/Models/screens/meeting_connexion.dart';
import 'package:synthiapp/Widgets/app_bar.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/config/config.dart';

class MeetingConnexion extends StatefulWidget {
  const MeetingConnexion() : super();

  @override
  _MeetingConnexionState createState() => _MeetingConnexionState();
}

class _MeetingConnexionState extends State<MeetingConnexion> {
  MeetingConnexionController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = MeetingConnexionController(this);
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
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: steps.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                steps[index].action!();
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
              onPressed: () => utils.pushReplacementScreen(
                  context, const MeetingConnexion()),
            ),
          if (!_controller!.model.currentStep.onError)
            SynthiaButton(
              text: 'Commencer',
              textColor: Theme.of(context).primaryColor,
              color: Theme.of(context).accentColor,
              enable: false,
              onPressed: () {},
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
