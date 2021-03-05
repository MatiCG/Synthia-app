import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:synthiaapp/Classes/download_file.dart';
import 'package:synthiaapp/Models/detail_page.dart';

class DetailPageController {
  final DetailPageModel model = DetailPageModel();

  /// Download the meeting report if is available
  void downloadReport(String meetingID) async {
    // Get the extension of the report file set by the user
    String reportExtension = await model.reportExtension;
    // Get the report url depending of the meeting ID and report Ext
    String reportUrl = await model.getReportUrl(
      meetingID: meetingID,
      reportExtension: reportExtension,
    );
    // Setup filename
    DateTime date = DateTime.now();
    String filename =
        'report_synthia_${date.toString()}.$reportExtension';

    DownloadFile download = DownloadFile();

    if (reportUrl == null) {
      print('The report is not available or a error occured !');
      return;
    }
    // First init the class [mandatory]
    await download.init();
    // Start downloading
    download.start(
      url: reportUrl,
      filename: filename,
    );
  }

  void shareMeeting(
      context, DocumentSnapshot post, TextEditingController customController) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
        .collection('meetings')
        .where('title', isEqualTo: post.data()['title'])
        .get()
        .then((value) {
      firestore.collection('meetings').doc().update({
        'members': FieldValue.arrayUnion([customController.text.toString()])
      });
    });
    Navigator.of(context).pop();
/*
      firestore
          .collection("meetings")
          .where('title', isEqualTo: post.data['title'])
          .getDocuments()
          .then((QuerySnapshot meetings) {
            firestore
                .collection("meetings")
                .document(meetings.documents[0].documentID)
                .updateData({
              "members": FieldValue.arrayUnion(
                  [customController.text.toString()])
            }).then((_) {});
      });
      Navigator.of(context).pop();
*/
  }
}
