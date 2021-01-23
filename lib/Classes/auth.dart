import 'package:firebase_auth/firebase_auth.dart';


/// This class control authentification
/// for firebase's users

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Get user status - get differents status
  /// Return 'SIGNEDIN' - user alreay signIn
  /// Return NOTSIGNEDIN - user not signIn
  Future<String> userStatus() async {
    String status = await this.currentUser();
    return status == null ? 'NOTSIGNEDIN' : 'SIGNEDIN';
  }

  /// Create new Firebase user with
  /// Email & Password comnbinaison
  Future<dynamic> createUser(String email, String password) async {
    try {
      final AuthResult result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = 'user${result.user.uid.substring(0, 3).toUpperCase()}';
      await result.user.updateProfile(userUpdateInfo);
      return result.user.uid;
    } catch (error) {
      print('An error occured when creating new user !\n$error');
      return error;
    }
  }

  /// Retrieve the current user object
  /// Return NULL in case of any user logged
  Future<dynamic> getUser() async {
    final FirebaseUser _user = await _firebaseAuth.currentUser();
    return _user != null ? _user : null;
  }

  /// Retrieve the current user uid logged
  /// Return NULL in case of any user logged
  Future<dynamic> currentUser() async {
    final FirebaseUser _user = await _firebaseAuth.currentUser();
    return _user != null ? _user.uid : null; //.uid : null;
  }

  /// Retrieve the email of the current user
  /// Return NULL in case of any user logged
  Future<String> currentUserEmail() async {
    final FirebaseUser _user = await _firebaseAuth.currentUser();
    return _user != null ? _user.email : null;
  }

  /// SignIn new user
  Future<dynamic> signIn(String email, String password) async {
    try {
      final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user.uid;
    } catch (error) {
      print('An error occured when signIn user !\n${error.message}');
      return error;
    }
  }

  /// Loggout the current user
  void signOut() async {
    try {
      _firebaseAuth.signOut();
    } catch (error) {
      print('An error occured when signOut user !\n${error.message}');
    }
  }
}
