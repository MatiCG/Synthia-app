import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:synthiapp/WebMobileFunction/mobile/save_and_launch_file.dart'
    if (dart.library.html) 'package:synthiapp/WebMobileFunction/web/save_and_launch_file.dart';

enum PageStatus {
  progress,
  completed,
}

class DetailMeetingController {
  final State<StatefulWidget> parent;
  final Meeting meeting;

  DetailMeetingController({required this.parent, required this.meeting});

  /// Check if the date of the meeting match with the current date
  bool isTodaysDate() {
    final date = DateTime.now();
    final meetingDate = meeting.date.toDate();

    if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(meetingDate)) {
      return true;
    }
    return false;
  }

  Future<PageStatus> getPageStatus() async {
    final data =
        await FirebaseFirestore.instance.doc(meeting.document.path).get();

    if (SynthiaFirebase().checkSnapshotDocument(data, keys: ['resume'])) {
      if (((data.data()!)['resume'] as String).isNotEmpty) {
        return PageStatus.completed;
      }
    }
    return PageStatus.progress;
  }

  Future<void> createPDF(String content, String title) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();

    final PdfFont fontTitle = PdfStandardFont(PdfFontFamily.timesRoman, 30);

    final PdfTextElement titleElement =
        PdfTextElement(text: title, font: fontTitle);

    final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
        layoutType: PdfLayoutType.paginate,
        breakType: PdfLayoutBreakType.fitPage);

    final Size size = fontTitle.measureString(title);

    final PdfLayoutResult result = titleElement.draw(
        page: page,
        bounds: Rect.fromLTWH(
            (page.getClientSize().width / 2) - (size.width / 2),
            0,
            page.getClientSize().width,
            page.getClientSize().height),
        format: layoutFormat)!;

    final PdfTextElement contentElement = PdfTextElement(
        text: content, font: PdfStandardFont(PdfFontFamily.timesRoman, 12));

    contentElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 10,
            page.getClientSize().width, page.getClientSize().height),
        format: layoutFormat);

    final List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, '$title.pdf');
  }
}
/*
class DetailMeetingController {
  final String meetingId;
  final State<StatefulWidget> parent;
  final DetailMeetingModel model = DetailMeetingModel();

  DetailMeetingController(this.parent, this.meetingId) {
    getMeeting();
  }

  Future getMeeting() async {
    final SynthiaFirebase _firebase = SynthiaFirebase();
    final DocumentSnapshot? meeting = await _firebase.fetchMeetingById(meetingId);

    if (meeting != null) {
      if (checkKeysExist(meeting,
          ['title', 'members', 'schedule', 'order', 'description', 'note'])) {
        final data = meeting.data()! as Map<String, dynamic>;
        final List<dynamic> members = data['members'] as List;
        final List<String> membersName = [];

        for (final member in members as List<DocumentReference>) {
          final String memberName = await _firebase.fetchUserRefDataByType(
              member, UserRefData.fullname);
          membersName.add(memberName);
        }
        if (parent.mounted) {
          utils.updateView(parent, update: () {
            model.setMembers = membersName;
            model.setTitle = data['title'] as String;
            model.setDescription = data['description'] as String;
            model.setOrder = data['order'] as String;
            model.setNote = data['note'] as String;
            model.setResume = data['resume'] as String;
            model.setKeywords = data['keywords'] as String;
            model.setDate = data['schedule'] as Timestamp;
          });
        }
      }
    }
  }

  bool checkKeysExist(DocumentSnapshot document, List<String> keys) {
    bool notMissingOne = true;
    Map<String, dynamic> data;

    if (document.data() == null) return false;
    data = document.data()! as Map<String, dynamic>;
    for (final key in keys) {
      if (!data.containsKey(key)) {
        notMissingOne = false;
      }
    }
    return notMissingOne;
  }

  bool isMeetingComplete() {
    if (model.resume != '' || model.keywords != '') return true;
    return false;
  }
}
*/