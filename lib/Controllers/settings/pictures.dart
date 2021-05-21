import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Models/settings/pictures.dart';
import 'package:synthiapp/config/config.dart';

class SettingsPicturesController {
  SettingsPicturesModel model = SettingsPicturesModel();

  SettingsPicturesController() {
    model.images.forEach((element) {
      if (element.path ==
          (user.data?.photoURL ?? 'assets/avatars/blank.png')) {
        element.isSelected = true;
      }
    });
  }

  updateSelection(int index, State<StatefulWidget> parent) {
    // ignore: invalid_use_of_protected_member
    parent.setState(() {
      model.images.forEach((element) {
        element.selection = false;
      });
      model.images[index].selection = true;
      model.updating = true;
    });

    user.updateProfilePath(model.images[index].path).then((_) {
      // ignore: invalid_use_of_protected_member
      parent.setState(() {
        model.updating = false;
      });
    });

    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'photoUrl': model.images[index].path,
    }).then((value) {
    });
  }
}
