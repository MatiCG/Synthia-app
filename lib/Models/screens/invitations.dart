import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationModel {
  List<DocumentSnapshot<Object?>>? invitations = [];
  int selected = 0;

  /// Tile item
  String masterFullname = '';
  String masterPhotoUrl = 'assets/avatars/blank.png';
  String meetingTitle = '';
  String meetingDate = '';
  String invitationDate = '';

  InvitationModel();

  DocumentSnapshot<Object?>? get invitationSelected =>
      invitations?.elementAt(selected);

  void removeInvitation(int index) => invitations?.removeAt(index);
  void removeCurrentInvitation() => invitations?.removeAt(selected);
}
