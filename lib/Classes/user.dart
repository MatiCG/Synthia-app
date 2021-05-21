
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

//import 'package:firebase_auth/firebase_auth-1.1.0/lib/src/user.dart';
class SynthiaUser {
  // Set all the rights of the user
  StreamController<String> _rightsController = StreamController<String>();
  List<Right> _rights = [];
  // Create firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SynthiaUser() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        _rightsController.close();
        _rights = [];
        _rightsController = StreamController<String>();
      }
      if (user != null) fetchUserRights();
    });
  }

  /// Search all the rights that the user have
  fetchUserRights() async {
    final SynthiaFirebase myFunctions = SynthiaFirebase();
    final DocumentSnapshot document =
        await _firestore.collection('users').doc(user.uid).get();

    myFunctions.findRightsInDocuments(
      documents: document['rights'],
      callback: (right) {
        _rightsController.add(right);
      },
    );
  }

  /// Sign in the user into firebase. Email/Password
  signIn({required final String email, required final String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      log('SIGN-IN error: $error');
    }
  }

  _getDataById(List<SynthiaTextFieldItem> data, FieldsID id) {
    return data
        .firstWhere((element) => element.id == id)
        .controller
        .text
        .toLowerCase();
  }

  /// Register a new user into firebase
  register({required final List<SynthiaTextFieldItem> data}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: getDataById(FieldsID.EMAIL, data),
        password: getDataById(FieldsID.PASSWORD, data),
      );

      if (userCredential.user != null) {
        userCredential.user!.updateProfile(
          displayName:
              '${getDataById(FieldsID.FIRSTNAME, data)} ${getDataById(FieldsID.LASTNAME, data)}',
          photoURL: 'assets/avatars/blank.png',
        );
        FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': _getDataById(data, FieldsID.EMAIL),
          'photoUrl': 'assets/avatars/blank.png',
          'firstname': _getDataById(data, FieldsID.FIRSTNAME),
          'lastname': _getDataById(data, FieldsID.LASTNAME),
          'rights': [],
        });
      }
    } catch (error) {
      log('An error occured when register: $error');
    }
  }

  Future updateProfilePath(String path) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateProfile(
        photoURL: path,
      );
    }
  }

  getDataById(FieldsID id, List<SynthiaTextFieldItem> fields) {
    return fields.where((element) => element.id == id).first.controller.text;
  }

  /// Check if the user has the [right]
  bool hasRight(String right) {
    bool exist = false;

    _rights.forEach((userRight) {
      if (userRight.id == right) {
        exist = true;
      }
    });

    return exist;
  }

  /// Retrieve the stream of the user auth status
  Stream get stream => _auth.authStateChanges();

  /// Sign out user
  signOut() {
    _auth.signOut();
  }

  // Setters

  /// Add a new right to the user
  addNewRight(String right, {bool upload = false}) async {
    _rights.add(Right(id: right));
    if (upload) {
      var tmp = await _firestore.collection('rights').get();

      List<DocumentReference> rightsRef = [];

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
  removeRight(String right, {bool upload = false}) async {
    _rights.removeWhere((element) => element.id == right);

    if (upload) {
      var tmp = await _firestore.collection('rights').get();

      List<DocumentReference> rightsRef = [];

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
