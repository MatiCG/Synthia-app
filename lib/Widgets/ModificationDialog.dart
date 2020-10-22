
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModificationDialog extends StatelessWidget {
  ModificationDialog({
    @required this.title,
    @required this.content,
    @required this.controllers,
    @required this.setEditing,
    @required this.context
  }) : super();

  final String title;
  final String content;
  final List<TextEditingController> controllers;
  final Function setEditing;
  final BuildContext context;

  List<Widget> actionsButtons() {
    return [
      FlatButton(
        onPressed: () {
          setEditing(true);
          Navigator.pop(context);
        },
        child: Text('Annuler'),
      ),
      FlatButton(
        onPressed: () {
          controllers.forEach((element) {
            element.clear();
          });
          setEditing(false);
          Navigator.pop(context);
        },
        child: Text('Continuer'),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actionsButtons(),
      );
    } else {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actionsButtons(),
      );
    }
  }
}
