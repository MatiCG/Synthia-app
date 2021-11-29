import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:synthiapp/Views/details_meeting/progress_details.dart';
import 'package:synthiapp/Views/details_meeting/progress_title.dart';
import 'package:synthiapp/WebMobileFunction/mobile/save_and_launch_file.dart'
    if (dart.library.html) 'package:synthiapp/WebMobileFunction/web/save_and_launch_file.dart';

enum PageStatus {
  progress,
  completed,
}

class DetailMeetingController {
  final State<StatefulWidget> parent;
  late ProgressController progress;
  Meeting meeting;

  DetailMeetingController({required this.parent, required this.meeting}) {
    progress = ProgressController(meeting);
  }

  /// Check if the date of the meeting match with the current date
  bool isTodaysDate() {
    final date = DateTime.now();
    final meetingDate = meeting.date!;

    if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(meetingDate)) {
      return true;
    }
    return false;
  }

  String? getKeywordsFromSnapshot(Object data) {
    if (data is DocumentSnapshot<Map<String, dynamic>> &&
      SynthiaFirebase().checkSnapshotDocument(data, keys: ['keyWords'])) {
      final String resume = data.data()!['keyWords'] as String;

      if (resume.isNotEmpty) {
        return resume;
      }
    }
    return null;
  }

  String? getResumeFromSnapshot(Object data) {
    if (data is DocumentSnapshot<Map<String, dynamic>> &&
        SynthiaFirebase().checkSnapshotDocument(data, keys: ['resume'])) {
      final String resume = data.data()!['resume'] as String;

      if (resume.isNotEmpty) {
        return resume;
      }
    }
    return null;
  }

  PageStatus getPageStatus(Object data) {
    if (data is DocumentSnapshot<Map<String, dynamic>> &&
        SynthiaFirebase().checkSnapshotDocument(data, keys: ['resume'])) {
      if ((data.data()!['resume'] as String).isNotEmpty) {
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

class ProgressController {
  Meeting meeting;
  List<Widget> items = [];

  ProgressController(this.meeting) {
    items
      ..add(MeetingProgressTitle(title: meeting.title))
      ..add(MeetingProgressDetails(meeting: meeting));
  }
}
