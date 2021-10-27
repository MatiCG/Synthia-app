import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/creation_meeting.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/list.dart';

class CreationMeetingPage extends StatefulWidget {
  final bool edit;
  final Meeting? meeting;

  const CreationMeetingPage({this.edit = false, this.meeting})
      : assert(edit == false || meeting != null),
        super();

  @override
  _CreationMeetingPageState createState() => _CreationMeetingPageState();
}

class _CreationMeetingPageState extends State<CreationMeetingPage> {
  late final CreateMeetingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CreateMeetingController(widget.edit, existMeeting: widget.meeting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SynthiaList(
          itemCount: _controller.items.length,
          itemBuilder: (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _controller.items[index],
            );
          },
          footer: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SynthiaButton(
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              text: widget.edit ? 'Modifier la réunion' : 'Créer la réunion',
              onPressed: () => widget.edit ? _controller.submitEdit(context) : _controller.submit(context),
            ),
          ),
        ),
      ),
    );
  }
}
