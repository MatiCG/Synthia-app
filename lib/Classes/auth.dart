import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

enum userAuthState {
  CONNECTED,
  NOT_CONNECTED,
}

/// This class control the authentification for
/// firebase users;
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _user;
  // ignore: close_sinks
  StreamController<userAuthState> _streamController;
  Stream _stream;

  Auth() {
    // Configuring the stream that listen to the user state
    _streamController = StreamController<userAuthState>();
    _stream = _streamController.stream;

    // get the current user status and add the value to the stream.
    _streamController.add(userStatus);

    // Set the value of the user object to the current user
    _user = _firebaseAuth.currentUser;
//    _firebaseAuth.currentUser().then((value) => _user = value);
  }

  /// Create a new firebase user with Email and Password combinaison
  Future<dynamic> createUser(String email, String password) async {
    UserCredential result;

    try {
      result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Define the user basics information
      user.updateProfile(
        displayName: 'user${result.user.uid.substring(0, 3).toUpperCase()}',
        photoURL:
            'https://firebasestorage.googleapis.com/v0/b/synthia-app-eip.appspot.com/o/default_profile_picture.png?alt=media&token=7b35cd9e-41cb-490e-9ed8-c35889d3a48c',
      );
      await user.reload();
      this.updateUser();
    } catch (error) {
      print('An error occured when creating a new user.\n${error.message}');
      return error;
    }
    return result.user.uid;
  }

  /// SignIn a firebase user with email and password combinaison
  Future<dynamic> signIn(String email, String password) async {
    UserCredential result;

    try {
      result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      this.updateUser();
    } catch (error) {
      print('An error occured when signIn user.\n${error.message}');
      return error;
    }
    return result.user.uid;
  }

  /// Loggout the current user
  void signOut() async {
    try {
      await _firebaseAuth.signOut();
      this.updateUser();
    } catch (error) {
      print('An error occured when signOut user !\n${error.message}');
    }
  }

  // Setters
  set userPhotoUrl(String url) {}

  set user(User user) => this._user = user;

  // Getters

  /// Retrieve the current user object
  User get user => this._user;

  /// Retrieve the stream of the user authentification
  Stream get stream => this._stream;

  /// Get the user authentification status. CONNECTED or NOT_CONNECTED
  userAuthState get userStatus {
    final User user = this._firebaseAuth.currentUser;
    return user != null ? userAuthState.CONNECTED : userAuthState.NOT_CONNECTED;
  }

  // Setters

  /// Set the current user object and update the value for the stream
  void updateUser() {
    this._user = _firebaseAuth.currentUser;
    this._user != null
        ? _streamController.add(userAuthState.CONNECTED)
        : _streamController.add(userAuthState.NOT_CONNECTED);
  }
}
