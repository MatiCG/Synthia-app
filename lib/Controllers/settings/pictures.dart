import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Models/settings/pictures.dart';
import 'package:synthiapp/config/config.dart';

class SettingsPicturesController {
  SettingsPicturesModel model = SettingsPicturesModel();

  SettingsPicturesController() {
    for (final image in model.images) {
      if (image.path == (user.data?.photoURL ?? 'assets/avatars/blank.png')) {
        image.isSelected = true;
      }
    }
  }

  void updateSelection(int index, State<StatefulWidget> parent) {
    utils.updateView(parent, update: () {
      for (final image in model.images) {
        image.selection = false;
      }
      model.images[index].selection = true;
      model.updating = true;
    });

    utils.updateView(parent, update: () {
      model.updating = false;
    });
    /*
    // ignore: invalid_use_of_protected_member
    parent.setState(() {
      for (final image in model.images) {
        image.selection = false;
      }
      model.images[index].selection = true;
      model.updating = true;
    });
    */

    /*
    user.updateProfilePath(model.images[index].path).then((_) {
      // ignore: invalid_use_of_protected_member
      parent.setState(() {
        model.updating = false;
      });
    });
    */

    if (user.data != null) {
      user.data!.updatePhotoURL(model.images[index].path);
    }
    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'photoUrl': model.images[index].path,
    }).then((value) {
      log('updated');
    });
  }
}
