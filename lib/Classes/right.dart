enum RightID {
  anyNotifications,
  meetingInvitation,
  meetingUpdated,
  meetingRemember,
  reportSendEmail,
  reportPdfFile,
  reportTxtFile,
}

extension RightExt on RightID {
  String get asString {
    switch (this) {
      case RightID.anyNotifications:
        return 'any_notifications';
      case RightID.meetingInvitation:
        return 'meeting_invitation';
      case RightID.meetingUpdated:
        return 'meeting_updated';
      case RightID.meetingRemember:
        return 'meeting_remember';
      case RightID.reportSendEmail:
        return 'report_send_email';
      case RightID.reportPdfFile:
        return 'report_pdf_file';
      case RightID.reportTxtFile:
        return 'report_txt_file';
    }
  }
}

class Right {
  final String id;

  Right({required this.id});
}
