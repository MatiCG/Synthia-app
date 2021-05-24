import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';

class DetailMeetingPage extends StatefulWidget {
  final String _meetingId;

  DetailMeetingPage(this._meetingId) : super();

  @override
  _DetailMeetingPageState createState() => _DetailMeetingPageState();
}

class _DetailMeetingPageState extends State<DetailMeetingPage> {
  DetailMeetingController? _controller;

  @override
  void initState() {
    super.initState();

    setState(() {
      _controller = DetailMeetingController(this, widget._meetingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null)
      return Scaffold(backgroundColor: Theme.of(context).primaryColor);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
