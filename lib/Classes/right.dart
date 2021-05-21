enum RightID {
  ANY_NOTIFICATIONS,
  MEETING_INVITATION,
  MEETING_UPDATED,
  MEETING_REMEMBER,
  REPORT_SEND_EMAIL,
  REPORT_PDF_FILE,
  REPORT_TXT_FILE,
}

extension RightExt on RightID {
  get asString {
    switch (this) {
      case RightID.ANY_NOTIFICATIONS:
        return 'any_notifications';
      case RightID.MEETING_INVITATION:
        return 'meeting_invitation';
      case RightID.MEETING_UPDATED:
        return 'meeting_updated';
      case RightID.MEETING_REMEMBER:
        return 'meeting_remember';
      case RightID.REPORT_SEND_EMAIL:
        return 'report_send_email';
      case RightID.REPORT_PDF_FILE:
        return 'report_pdf_file';
      case RightID.REPORT_TXT_FILE:
        return 'report_txt_file';
    }
  }
}

class Right {
  final String id;

  Right({required this.id});
}
