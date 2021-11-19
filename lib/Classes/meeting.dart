import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Meeting {
  final mandatoryKeys = [
    'title',
    'members',
    'order',
    'note',
    'resume',
    'members',
    'date',
    'startAt',
    'endAt',
  ];
  late String title;
  late String order;
  late String notes;
  late String resumee;
  late List<dynamic> members;
  DateTime? date;
  TimeOfDay? startAt;
  TimeOfDay? endAt;
  late DocumentReference? document;
  late String master;

  Meeting({
    this.title = '',
    this.order = '',
    this.notes = '',
    this.resumee = '',
    this.members = const [],
    this.date,
    this.startAt,
    this.endAt,
    this.document,
    this.master = '',
  });

  Meeting.create() {
    title = '';
    order = '';
    notes = '';
    resumee = '';
    members = [];
    master = '';
    document = null;
    date = DateTime.now();
    startAt = TimeOfDay.now();
    endAt = TimeOfDay.now();
  }

  Map toJson() => {
        'title': title,
        'order': order,
        'notes': notes,
        'resume': resumee,
        'members': members,
        'date': date,
        'startAt': startAt,
        'endAt': endAt,
        'document': document,
        'master': master,
      };
}
