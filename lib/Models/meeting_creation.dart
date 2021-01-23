class MeetingCreationModel {
  String _meetingTitle = 'Click to modify';
  String _meetingDescription = 'Click to modify';
  String _meetingOrder = 'Click to modify';
  List<String> _members = List<String>();

  /// Add new member
  void addNewMember(String value) {
    this._members.add(value);
  }

  /// Remove member
  void removeMember(String value) {
    this._members.remove(value);
  }

  /// Set meeting title value
  void setMeetingTitle(String value) {
    this._meetingTitle = value;
  }

  /// Set meeting description value
  void setMeetingDescription(String value) {
    this._meetingDescription = value;
  }

  /// Set meeting order value
  void setMeetingOrder(String value) {
    this._meetingOrder = value;
  }

  /// Get meeting title value
  String getMeetingTitle() {
    return this._meetingTitle;
  }

  /// Get meeting description value
  String getMeetingDescription() {
    return this._meetingDescription;
  }

  /// Get meeting order value
  String getMeetingOrder() {
    return this._meetingOrder;
  }

  /// Get the list of the members
  List<String> getMeetingMembers() {
    return this._members;
  }

  /// Get a specific member depending of the INDEX
  String getSpecificMember(int index) {
    return this._members.elementAt(index);
  }
}
