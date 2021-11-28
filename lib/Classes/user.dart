/// This class is used to handle and retrieve data of the user
/// anywhere.
/// All variables must have getter and be private.

import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synthiapp/Classes/right.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Widgets/textfield.dart';
import 'package:synthiapp/config/config.dart';

enum UserState {
  connected,
  disconnected,
}

class SynthiaUser {
  // Set all the rights of the user
  StreamController<String> _rightsController = StreamController<String>();
  final StreamController<UserState> _userState = StreamController<UserState>();
  List<Right> _rights = [];
  // Create firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userToken = '';

  SynthiaUser() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        authFlag = false;
        _userState.add(UserState.disconnected);
        _rightsController.close();
        _rights = [];
        _rightsController = StreamController<String>();
      }
      if (user != null) {
        if (!authFlag) _userState.add(UserState.connected);
        authFlag = true;
        fetchUserRights();
      }
    });
  }

  /// Search all the rights that the user have
  Future fetchUserRights() async {
    final SynthiaFirebase myFunctions = SynthiaFirebase();
    final DocumentSnapshot document =
        await _firestore.collection('users').doc(user.uid).get();

    myFunctions.findRightsInDocuments(
      documents: document['rights'] as List,
      callback: (right) {
        _rightsController.add(right);
      },
    );
  }

  /// Sign in the user into firebase. Email/Password
  Future<String> signIn(
      {required final String email, required final String password}) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        _userToken = documentSnapshot.get('token').toString();
      });
      return '';
    } catch (error) {
      log('SIGN-IN error: $error');
      return error.toString();
    }
  }

  String _getDataById(List<SynthiaTextFieldItem> data, FieldsID id) {
    return data
        .firstWhere((element) => element.id == id)
        .controller
        .text
        .toLowerCase();
  }

  /// Register a new user into firebase
  Future register({required final List<SynthiaTextFieldItem> data}) async {
    const avatarPath = 'assets/avatars/blank.png';

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: getDataById(FieldsID.email, data),
        password: getDataById(FieldsID.password, data),
      );

      if (userCredential.user != null) {
        userCredential.user!.updateDisplayName(
            '${getDataById(FieldsID.firstname, data)} ${getDataById(FieldsID.lastname, data)}');
        userCredential.user!.updatePhotoURL(avatarPath);

        FirebaseFirestore.instance
            .collection('tokens')
            .add({'user': _getDataById(data, FieldsID.email)}).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'email': _getDataById(data, FieldsID.email),
            'photoUrl': avatarPath,
            'firstname': _getDataById(data, FieldsID.firstname),
            'lastname': _getDataById(data, FieldsID.lastname),
            'rights': [],
            'token': value.id,
          });
          _userToken = value.id;
        });
      }
    } catch (error) {
      log('An error occured when register: $error');
    }
  }

  String getUserToken() {
    return _userToken;
  }

  Future updateProfilePath(String path) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updatePhotoURL(path);
    }
  }

  String getDataById(FieldsID id, List<SynthiaTextFieldItem> fields) {
    return fields.where((element) => element.id == id).first.controller.text;
  }

  /// Check if the user has the [right]
  bool hasRight(RightID givenRight) {
    bool exist = false;

    for (final right in _rights) {
      if (right.id == givenRight.asString) {
        exist = true;
      }
    }
    return exist;
  }

  /// Retrieve the stream of the user auth status
  Stream get stream => _userState.stream;

  /// Sign out user
  void signOut() {
    _auth.signOut();
  }

  // Setters

  /// Add a new right to the user
  Future addNewRight(String right, {bool upload = false}) async {
    _rights.add(Right(id: right));
    if (upload) {
      final tmp = await _firestore.collection('rights').get();
      final List<DocumentReference> rightsRef = [];

      tmp.docs
          .where((element) => element.data()['title'] == right)
          .forEach((element) {
        rightsRef.add(element.reference);
      });

      _firestore.collection('users').doc(user.uid).update({
        'rights': FieldValue.arrayUnion(rightsRef),
      }).then((value) {});
    }
  }

  /// Add a new right to the user
  Future removeRight(String right, {bool upload = false}) async {
    _rights.removeWhere((element) => element.id == right);

    if (upload) {
      final tmp = await _firestore.collection('rights').get();
      final List<DocumentReference> rightsRef = [];

      tmp.docs
          .where((element) => element.data()['title'] == right)
          .forEach((element) {
        rightsRef.add(element.reference);
      });

      _firestore.collection('users').doc(user.uid).update({
        'rights': FieldValue.arrayRemove(rightsRef),
      }).then((value) {});
    }
  }

  // Getters
  List<Right> get rights => _rights;
  Stream get searchRights => _rightsController.stream;

  /// Retrieve the user object
  User? get data => _auth.currentUser;
  String get uid => _auth.currentUser?.uid ?? '';
}
