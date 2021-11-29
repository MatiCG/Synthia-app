import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Views/details_meeting/meeting_completed.dart';
import 'package:synthiapp/Views/details_meeting/meeting_in_progress.dart';

class DetailMeetingPage extends StatefulWidget {
  final Meeting meeting;

  const DetailMeetingPage({required this.meeting}) : super();

  @override
  _DetailMeetingPageState createState() => _DetailMeetingPageState();
}

class _DetailMeetingPageState extends State<DetailMeetingPage> {
  late DetailMeetingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = DetailMeetingController(
      parent: this,
      meeting: widget.meeting,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          SynthiaFirebase().fetchReportResumeStream(widget.meeting.document!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final PageStatus status = _controller.getPageStatus(snapshot.data!);
          if (status == PageStatus.progress) {
            return DetailMeetingProgress(
              controller: _controller,
            );
          } else {
            return DetailMeetingCompleted(
              controller: _controller,
              resume: _controller.getResumeFromSnapshot(snapshot.data!),
              keywords: _controller.getKeywordsFromSnapshot(snapshot.data!),
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}