import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Widgets/list_members.dart';

class MeetingProgressMembers extends StatelessWidget {
  final Meeting meeting;

  const MeetingProgressMembers({required this.meeting});

  @override
  Widget build(BuildContext context) {
    return ListMembers(members: meeting.members);
  }
}
