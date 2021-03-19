import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/config.dart';

class DetailPageModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Retrieve the report Url if is available according to the type of file
  /// selected by the user
  Future<String> getReportUrl(
      {String meetingID, String reportExtension}) async {
    DocumentSnapshot result =
        await firestore.doc('meetings/' + meetingID).get();
    String url;

    if (result['report_url'].length == 0) {
      return null;
    }
    result['report_url'].forEach((iurl) {
      if (iurl.contains(reportExtension)) {
        url = iurl;
      }
    });
    return url;
  }

  /// Retrieve the type of the report selected by the user
  Future<String> get reportExtension async {
    DocumentSnapshot result =
        await firestore.doc('users/' + auth.user.uid).get();
    return result['settings_report_format'];
  }
}
