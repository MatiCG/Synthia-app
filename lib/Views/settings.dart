import 'package:flutter/material.dart';
import 'package:synthiaapp/Controllers/settings.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.authStatusController}) : super();

  final VoidCallback authStatusController;
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsController _controller;

  @override
  void initState() {
    super.initState();

    _controller = SettingsController(parent: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                ),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    buildTitleSection('Notifications'),
                    buildListItem(
                      'Invitation',
                      'You\'ll receive a notification after being invited to a meeting.',
                      _controller.isMeetingJoinSelected(),
                      (bool value) => _controller.setMeetingJoin(value),
                    ),
                    buildListItem(
                      'Schedule',
                      'You\'ll receive a notification as soon as a meeting is about to start.',
                      _controller.isMeetingScheduleSelected(),
                      (bool value) => _controller.setMeetingSchedule(value),
                    ),
                    buildListItem(
                      'Updated',
                      'You\'ll receive a notification as soon as a meeting is updated.',
                      _controller.isMeetingUpdateSelected(),
                      (bool value) => _controller.setMeetingUpdate(value),
                    ),
                    buildTitleSection('Report'),
                    buildListItem(
                      'Mailing Report',
                      'You\'ll receive the report of all the meetings right when it will be available.',
                      _controller.isReportEmailSelected(),
                      (bool value) => _controller.setReportEmail(value),
                    ),
                    buildListItem(
                      'Pdf Format',
                      'If this option is checked you\'ll receive a pdf. Otherwise it will be a txt file.',
                      _controller.isReportFormatSelected(),
                      _controller.isReportEmailSelected() == true
                        ? (bool value) => _controller.setReportFormat(value)
                        : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build title for settings list
  Padding buildTitleSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  /// Build header for settigns page
  Widget buildHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildHeaderActionButtons(
                Icons.wb_sunny_outlined,
                null,
                Colors.yellow.shade900,
              ),
              buildHeaderActionButtons(
                Icons.privacy_tip_outlined,
                null,
                Colors.grey,
              ),
              buildHeaderActionButtons(
                Icons.delete_forever_outlined,
                () {
                  _controller.deleteAccount(widget.authStatusController);
                },
                Colors.red.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build action button for action buttons list
  Widget buildHeaderActionButtons(
      IconData icon, Function onPressed, dynamic color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(icon),
            color: color,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  /// Build list item for settings section
  Widget buildListItem(
      String title, String subtitle, bool value, Function onChanged) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SwitchListTile(
          activeColor: Theme.of(context).accentColor,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          value: value == null ? false : value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
