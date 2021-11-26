import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Models/screens/meeting_connexion.dart';

class MeetingConnexionController {
  final State<StatefulWidget> parent;
  final Meeting meeting;
  final MeetingConnexionModel model = MeetingConnexionModel();

  MeetingConnexionController(this.parent, this.meeting) {}
}
