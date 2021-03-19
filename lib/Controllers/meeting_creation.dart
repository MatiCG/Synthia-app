import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:synthiaapp/Models/meeting_creation.dart';
import 'package:synthiaapp/config.dart';
import 'package:uuid/uuid.dart';

class MeetingCreationController {
  MeetingCreationModel model = MeetingCreationModel();
  final FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  final dynamic parent;

  MeetingCreationController({this.parent}) {
    parent.setState(() {
      model.addNewMember(auth.user.email);
    });
  }

  /// Create the meeting in the database
  /// If an error occured return false
  Future<bool> createMeeting() async {
    String pattern = 'Click to modify';

    if (model.getMeetingTitle() == pattern ||
        model.getMeetingMembers().length < 1 ||
        model.getMeetingOrder() == pattern ||
        model.getMeetingOrder() == pattern) {
      print('Please fill all the fields');
      return false;
    } else {
      await databaseReference
          .collection('meetings')
          .doc(Uuid().v1())
          .set({
        'title': model.getMeetingTitle(),
        'description': model.getMeetingDescription(),
        'schedule': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'order': model.getMeetingOrder(),
        'members': model.getMeetingMembers(),
        'report_url': null,
        'keyWords': '',
        'resume': '',
      });
      return true;
    }
  }

  /// Set data depending of the section name
  void setValueBySection(String section, String value) {
    this.parent.setState(() {
      switch (section) {
        case 'title':
          model.setMeetingTitle(value);
          break;
        case 'description':
          model.setMeetingDescription(value);
          break;
        case 'order':
          model.setMeetingOrder(value);
          break;
      }
    });
  }

  /// Add a new member to the list
  void addNewMember(String value) async {
    if (value != null && value.isNotEmpty) {
      try {
        dynamic result = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(value);
        if (result.length > 0 && !model.getMeetingMembers().contains(value)) {
          parent.setState(() {
            model.addNewMember(value);
          });
        } else {
          print('This user can\'t be added or doesn\'t exist');
        }
      } catch (error) {
        print('An error occured. $error');
      }
    } else {
      print('This field can\'t be empty !');
    }
  }

  /// Retrieve data depending of the section name
  String getValueBySection(String section) {
    switch (section) {
      case 'title':
        return model.getMeetingTitle();
      case 'description':
        return model.getMeetingDescription();
      case 'order':
        return model.getMeetingOrder();
    }
    return 'error';
  }
}
