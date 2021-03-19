import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Models/settings.dart';
import 'package:synthiaapp/config.dart';

class SettingsController {
  SettingsModel model;
  final dynamic parent;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  SettingsController({this.parent}) {
    model = SettingsModel(parent: parent);
  }

  /// Delete the account of the current user
  void deleteAccount() async {
    await firestore.doc('users/' + auth.user.uid).delete();
    auth.user.delete();
    auth.signOut();
  }
}
