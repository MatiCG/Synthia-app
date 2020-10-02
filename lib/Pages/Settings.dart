import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:synthiaapp/Widgets/SettingsSection.dart';
import 'package:synthiaapp/Widgets/SynthiaButton.dart';
import '../Models/User.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({Key key, this.onSignOut}) : super(key: key);

  final VoidCallback onSignOut;
  @override
  Settings createState() => Settings(onSignOut: onSignOut);
}

class Settings extends State<SettingsWidget> {
  Settings({this.onSignOut});
  final User _user = User();
  final VoidCallback onSignOut;

  List<String> meeting_titles;
  List<String> meeting_subtiles;
  List<Function> meeting_functions;

  @override
  void initState() {
    super.initState();

    meeting_titles = [
      'Rejoindre une réunion',
      'Heure de la réunion',
      'Modification de la réunion'
    ];
    meeting_subtiles = [
      'Vous receverez une notification lorsque vous êtes invité à rejoindre une réunion',
      'Vous receverez une notification le jour de votre réunion',
      'Vous receverez une notification lorsqu\'une modifcation sera faite sur la réunion'
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
            titles: meeting_titles,
            subtitles: meeting_subtiles,
            values: [_user.getMeetingNew(), _user.getMeetingSchedule(), _user.getMeetingChange()],
            user: _user,
            notifications: [_user.setMeetingNew, _user.setMeetingSchedule, _user.setMeetingChange],
          ),
          SynthiaButton(
            text: 'Supprimer votre compte',
            icon: Icons.delete_outline,
            backgroundColor: Colors.red.shade600,
            action: () async {
              await _user.deleteUserAccount();
              onSignOut();
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
              color: Colors.blueAccent,
            ),
            title: Text('Modifier mon profile'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          buildDivider(),
          ListTile(
            leading: Icon(
              Icons.lock,
              color: Colors.blueAccent,
            ),
            title: Text('Modifier mot de passe'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Action a definir
            },
          ),
          buildDivider(),
          ListTile(
            leading: Icon(
              Icons.wb_sunny,
              color: Colors.blueAccent,
            ),
            title: Text('Activer le mode sombre'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Action a definir
            },
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
