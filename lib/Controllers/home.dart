import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Models/home.dart';

class HomeController {
  final HomeModel _model = HomeModel();

  /// Get the list of the meetings
  /// that the user has joinded
  Future<List<DocumentSnapshot>> getMeetingsList() async {
    return await _model.getMeetingsList();
  }
}
