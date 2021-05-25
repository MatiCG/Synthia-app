import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailMeetingModel {
  String _title = '';
  List<String> _members = [];
  String _description = '';
  String _note = '';
  String _order = '';
  String _resume = '';
  String _keywords = '';
  Timestamp _date = Timestamp(0, 0);

  DetailMeetingModel();

  String get title => _title;
  List<String> get members => _members;
  String get description => _description;
  String get note => _note;
  String get order => _order;
  String get resume => _resume;
  String get keywords => _keywords;
  Timestamp get date => _date;

  set setTitle(String title) => _title = title;
  set setMembers(List<String> members) => _members = members;
  set setDescription(String descritpion) => _description = descritpion;
  set setNote(String note) => _note = note;
  set setOrder(String order) => _order = order;
  set setResume(String resume) => _resume = resume;
  set setKeywords(String keywords) => _keywords = keywords;
  set setDate(Timestamp date) => _date = date;
}
