import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:synthiaapp/Widgets/SettingsSection.dart';
import 'package:synthiaapp/Widgets/SynthiaButton.dart';
import '../Models/User.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.onSignOut, this.setIndex}) : super(key: key);

  final VoidCallback onSignOut;
  Function setIndex;
  @override
  Settings createState() => Settings(onSignOut: onSignOut, setIndex: setIndex);
}

class Settings extends State<SettingsPage> {
  Settings({this.onSignOut, this.setIndex});
  final User _user = User();
  final VoidCallback onSignOut;
  Function setIndex;
  var alertdialog;

  // Meeting Section
  List<String> meetingTitles;
  List<String> meetingSubtiles;
  List<bool> meetingValues;

  // Compte Rendu Section
  List<String> crTitles;
  List<String> crSubtitles;
  List<bool> crValues;

  @override
  void initState() {
    super.initState();

    meetingTitles = [
      'Rejoindre une réunion',
      'Heure de la réunion',
      'Modification de la réunion'
    ];
    meetingSubtiles = [
      'Vous receverez une notification lorsque vous êtes invité à rejoindre une réunion',
      'Vous receverez une notification le jour de votre réunion',
      'Vous receverez une notification lorsqu\'une modifcation sera faite sur la réunion'
    ];
    crTitles = ['Recevoir le compte rendu par email', 'Choisir le format'];
    crSubtitles = [
      'Vous receverez le compte rendu directement dans votre boîte mail dès que celui-ci sera disponible. Vous pourrez quand même le télécharger sur l\'application',
      'Vous pouvez choisir le format de votre compte rendu. Vous avez le choix entre un format txt et pdf'
    ];
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _user.init(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return settingsWidget();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget settingsWidget() {
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: Column(children: [
          quickAccess(),
          SettingsSection(
            sectionTitle: 'Notifications',
            titles: meetingTitles,
            subtitles: meetingSubtiles,
            values: [
              _user.getMeetingNew(),
              _user.getMeetingSchedule(),
              _user.getMeetingChange()
            ],
            user: _user,
            notifications: [
              _user.setMeetingNew,
              _user.setMeetingSchedule,
              _user.setMeetingChange
            ],
          ),
          SettingsSection(
            sectionTitle: 'Compte Rendu',
            titles: crTitles,
            subtitles: crSubtitles,
            values: [_user.getReportEmail(), _user.getReportExtension()],
            user: _user,
            notifications: [_user.setReportEmail, _user.setReportExtension],
          ),
          SynthiaButton(
            top: 64.0,
            bottom: 32.0,
            text: 'Supprimer votre compte',
            leadingIcon: Icons.delete_outline,
            color: Colors.red.shade600,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return DeleteDialog(
                      title: 'Supprimer votre compte ?',
                      content:
                        'Cette action entraînera la suppression définitive de toutes les données de votre compte, y compris les documents et informations personnelles. Confirmez la suppression définitive de votre compte en saisissant :\n',
                      onSignOut: onSignOut,
                      user: _user,
                    );
                  });
            },
          )
        ]));
  }

  // QuickAccess Widget
  Widget quickAccess() {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Color.fromRGBO(58, 66, 86, 1.0),
            ),
            title: Text('Modifier mon profile'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              setIndex(1);
            },
          ),
          buildDivider(),
          ListTile(
            leading: Icon(
              Icons.lock,
              color: Color.fromRGBO(58, 66, 86, 1.0),
            ),
            title: Text('Modifier mot de passe'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          buildDivider(),
          ListTile(
            leading: Icon(
              Icons.wb_sunny,
              color: Color.fromRGBO(58, 66, 86, 1.0),
            ),
            title: Text('Activer le mode sombre'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Container buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}

class DeleteDialog extends StatefulWidget {
  DeleteDialog({
    @required this.title,
    @required this.content,
    @required this.onSignOut,
    @required this.user,
  }) : super();

  final String title;
  final String content;
  final VoidCallback onSignOut;
  final User user;

  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  final String _deleteKeyword = 'Supprimer définitivement mon compte';
  final controller = TextEditingController();
  Function deleteAccount;

  List<Widget> actionsButton() {
    return [
      FlatButton(
        child: Text('Annuler'),
        onPressed: () => Navigator.pop(context),
      ),
      FlatButton(
        child: Text('Supprimer'),
        onPressed: deleteAccount,
      )
    ];
  }

  RichText contentText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: Colors.black),
        children: [
          TextSpan(text: widget.content),
          TextSpan(
            text: '\n' + _deleteKeyword,
            style: TextStyle(fontWeight: FontWeight.bold)
          )
        ]
      ),
    );
  }

  void _deleteAccount() async {
    await widget.user.deleteUserAccount();
    widget.onSignOut();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(widget.title),
        content: Wrap(children: [
          contentText(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
            child: CupertinoTextField(
                controller: controller,
                placeholder: _deleteKeyword,
                onChanged: (text) {
                  if (text == _deleteKeyword) {
                    setState(() {
                      deleteAccount = () async {
                        _deleteAccount();
                      };
                    });
                  }
                },
                placeholderStyle: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
        ]),
        actions: actionsButton(),
      );
    } else {
      return AlertDialog(
        title: Text(widget.title),
        content: Wrap(children: [
          contentText(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
            child: TextField(
              onChanged: (text) {
                if (text == _deleteKeyword) {
                  setState(() {
                    deleteAccount = () async {
                      _deleteAccount();
                    };
                  });
                }
              },
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                hintText: _deleteKeyword,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(
                      color: Color.fromRGBO(58, 66, 86, 1.0), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
            ),
          ),
        ]),
        actions: actionsButton(),
      );
    }
  }
}
