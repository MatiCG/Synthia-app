import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/settings.dart';
import 'package:synthiapp/Models/screens/settings.dart';
import 'package:synthiapp/Views/settings/pictures.dart';
import 'package:synthiapp/Widgets/list_settings_item.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';
import 'package:synthiapp/config/config.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage() : super();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsController _controller = SettingsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 4.0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  _buildUserData(),
                  _buildAvatar(context),
                  _buildContent(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildContent(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.30,
      left: 0,
      right: 0,
      child: SynthiaScrollList(
        sections: _controller.model.sections,
        headerBuilder: (index) {
          ScrollSection section = _controller.model.sections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: Text(
              section.title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
        itemBuilder: (headerIndex, index) {
          SettingsItem item =
              _controller.model.sections[headerIndex].items[index];
          return ListSettingsItem(item: item);
        },
      ),
    );
  }

  Positioned _buildAvatar(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 0,
      right: 0,
      child: Container(
        height: 75,
        width: 75,
        child: InkWell(
          onTap: () async {
            String newPath = await Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SettingsPictures(),
                    transitionDuration: Duration(milliseconds: 500),
                    reverseTransitionDuration: Duration(milliseconds: 300)));
            setState(() {
              _controller.model.userPicture = newPath;
            });
          },
          child: Hero(
            tag: 'avatar',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(_controller.model.userPicture),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildUserData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.data?.email ?? '',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        Text(
          user.data?.displayName ?? '',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
