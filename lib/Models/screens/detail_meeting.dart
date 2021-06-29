import 'package:cloud_firestore/cloud_firestore.dart';

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

  // ignore: avoid_setters_without_getters
  set setTitle(String title) => _title = title;
  // ignore: avoid_setters_without_getters
  set setMembers(List<String> members) => _members = members;
  // ignore: avoid_setters_without_getters
  set setDescription(String descritpion) => _description = descritpion;
  // ignore: avoid_setters_without_getters
  set setNote(String note) => _note = note;
  // ignore: avoid_setters_without_getters
  set setOrder(String order) => _order = order;
  // ignore: avoid_setters_without_getters
  set setResume(String resume) => _resume = resume;
  // ignore: avoid_setters_without_getters
  set setKeywords(String keywords) => _keywords = keywords;
  // ignore: avoid_setters_without_getters
  set setDate(Timestamp date) => _date = date;
}
