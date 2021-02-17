import 'package:flutter/material.dart';
import 'package:synthiaapp/Controllers/settings.dart';
import 'package:synthiaapp/config.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage() : super();

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
                color: Theme.of(context).primaryColor,
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
                      _controller.model?.isJoinSelected ?? false,
                      (bool value) => _controller.model.setJoinSelected = value,
                    ),
                    buildListItem(
                      'Schedule',
                      'You\'ll receive a notification as soon as a meeting is about to start.',
                      _controller.model?.isScheduleSelected ?? false,
                      (bool value) =>
                          _controller.model.setScheduleSelected = value,
                    ),
                    buildListItem(
                      'Updated',
                      'You\'ll receive a notification as soon as a meeting is updated.',
                      _controller.model?.isUpdateSelected ?? false,
                      (bool value) =>
                          _controller.model.setUpdateSelected = value,
                    ),
                    buildTitleSection('Report'),
                    buildListItem(
                      'Mailing Report',
                      'You\'ll receive the report of all the meetings right when it will be available.',
                      _controller.model?.isMailingReportSelected ?? false,
                      (bool value) =>
                          _controller.model.setMailingReportSelected = value,
                    ),
                    buildListItem(
                      'Pdf Format',
                      'If this option is checked you\'ll receive a pdf. Otherwise it will be a txt file.',
                      _controller.model?.isFormatReportSelected ?? false,
                      _controller.model?.isMailingReportSelected ?? false
                          ? (bool value) =>
                              _controller.model.setFormatReportSelected = value
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
        style: Theme.of(context).textTheme.headline6,
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
                () {
                  theme.switchTheme();
                },
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
                  _controller.deleteAccount();
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
            style: Theme.of(context).textTheme.headline4,
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          value: value == null ? false : value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
