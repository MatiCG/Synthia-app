class DetailMeetingModel {
  String _title = '';
  List<String> _members = [];
  String _description = '';
  String _note = '';
  String _order = '';

  DetailMeetingModel();

  String get title => _title;
  List<String> get members => _members;
  String get description => _description;
  String get note => _note;
  String get order => _order;

  set setTitle(String title) => _title = title;
  set setMembers(List<String> members) => _members = members;
  set setDescription(String descritpion) => _description = descritpion;
  set setNote(String note) => _note = note;
  set setOrder(String order) => _order = order;
}
