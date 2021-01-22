import 'package:firebase_auth/firebase_auth.dart';
import 'package:synthiaapp/Classes/auth.dart';

class AccountModel {
  String _username;
  String _phonenumber;

  /// Get user object
  Future<FirebaseUser> getUser() async {
    return await Auth().getUser();
  }

  /// Get user tempory username
  String getEditUsername() {
    return _username;
  }

  /// Set user tempory username
  void setEditUsername(String value) {
    this._username = value;
  }

  /// Get user tempory PhoneNumber
  String getEditPhoneNumber() {
    return _phonenumber;
  }

  /// Set user tempory PhoneNumber
  void setEditPhoneNumber(String value) {
    this._phonenumber = value;
  }
}
