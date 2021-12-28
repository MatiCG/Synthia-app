library config.globals;

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:synthiapp/Classes/theme.dart';
import 'package:synthiapp/Classes/user.dart';
import 'package:synthiapp/Classes/utils.dart';

SynthiaUser user = SynthiaUser();
SynthiaTheme theme = SynthiaTheme();
Utils utils = Utils();
final Future<ByteData> cert = rootBundle.load('assets/synthia.crt');
final SecurityContext securityContext = SecurityContext.defaultContext;

/// This is a quick fix for an issue that i found on Firebase.
/// [authStateChanges] is called to many times for the same state and that
/// make the app reload to many times
/// I found people with the same issues at this link but not solutions
/// provided/founded
/// [https://stackoverflow.com/questions/37673616/firebase-android-onauthstatechanged-called-twice]
bool authFlag = false;
