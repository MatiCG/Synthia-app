import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/settings.dart';
import 'package:synthiapp/Models/screens/settings.dart';
import 'package:synthiapp/Views/settings/pictures.dart';
import 'package:synthiapp/Widgets/list_settings_item.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';
import 'package:synthiapp/config/config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage() : super();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController _controller = SettingsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 4.0),
            child: SizedBox(
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
          final ScrollSection section = _controller.model.sections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: Text(
              section.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
        itemBuilder: (headerIndex, index) {
          final SettingsItem item = _controller
              .model.sections[headerIndex].items[index] as SettingsItem;
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
      child: SizedBox(
        height: 75,
        width: 75,
        child: InkWell(
          onTap: () async {
            final String newPath = await Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SettingsPictures(),
                    transitionDuration: const Duration(milliseconds: 500),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 300))) as String;
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        Text(
          user.data?.displayName ?? '',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
