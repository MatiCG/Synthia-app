import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Views/Screens/creation_meeting.dart';
import 'package:synthiapp/Views/Screens/meeting_connexion.dart';
import 'package:synthiapp/Views/details_meeting/progress_details.dart';
import 'package:synthiapp/Views/details_meeting/progress_title.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/list_members.dart';
import 'package:synthiapp/config/config.dart';

class DetailMeetingProgress extends StatefulWidget {
  final DetailMeetingController controller;

  const DetailMeetingProgress({
    required this.controller,
  }) : super();

  @override
  _DetailMeetingProgressState createState() => _DetailMeetingProgressState();
}

class _DetailMeetingProgressState extends State<DetailMeetingProgress> {
  late DetailMeetingController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildNavbar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MeetingProgressTitle(title: controller.meeting.title),
          MeetingProgressDetails(meeting: controller.meeting),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListMembers(members: controller.meeting.members, editable: false),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SynthiaButton(
              text: 'Commencer',
              enable: widget.controller.isTodaysDate(),
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              onPressed: () => utils.pushScreen(
                  context,
                  MeetingConnexion(
                    meeting: widget.controller.meeting,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildNavbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.black),
          onPressed: () async {
            final updatedMeeting = await utils.futurePushScreen(
                context,
                CreationMeetingPage(
                    edit: true, meeting: widget.controller.meeting));
            if (updatedMeeting != null) {
              setState(() {
                widget.controller.progress.items =
                    widget.controller.progress.items;
                widget.controller.meeting = updatedMeeting as Meeting;
              });
            }
          },
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}