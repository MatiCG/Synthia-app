import 'package:uuid/uuid.dart';

var uuid = Uuid();

class MeetingData {
	String meetingId = uuid.v1();
	String meetingTitle;
	String meetingSubject;
	String meetingSchedule;
	List   meetingMembers = [];

	MeetingData({
		this.meetingTitle,
		this.meetingSubject,
		this.meetingSchedule
	});

	// Setters
	void setMeetingTitle(title) {
		this.meetingTitle = title;
	}
	void setMeetingSubject(subject) {
		this.meetingSubject = subject;
	}
	void setMeetingSchedule(schedule) {
		this.meetingSchedule = schedule;
	}
	void setListMeetingMembers(list) {
		this.meetingMembers = list;
	}
	void addMemberMeetingMembers(member) {
		this.meetingMembers.add(member);
	}

	// Getters
	String getMeetingTitle() {
		return this.meetingTitle;
	}
	String getMeetingSubject() {
		return this.meetingSubject;
	}
	String getMeetingSchedule() {
		return this.meetingSchedule;
	}
	List getMeetingMembers() {
		return this.meetingMembers;
	}
	String getMeetingId() {
		return this.meetingId;
	}

	// Get data as JSON
	Map<String, dynamic> getData() => {
		'title': this.meetingTitle,
		'description': this.meetingSubject,
		'schedule': this.meetingSchedule,
		'members': this.meetingMembers,
	};

	// Verify
	bool verify(index) {
		switch (index) {
			case 0:
				if (this.meetingTitle == null || this.meetingTitle.isEmpty ||
				this.meetingSubject == null || this.meetingSubject.isEmpty ||
				this.meetingSchedule == null || this.meetingSchedule.isEmpty) {
					return false;
				}
				break;
			case 1:
				if (this.meetingMembers.length <= 0) {
					return false;
				}
		}
		return true;
	}
}