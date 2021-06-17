import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/settings/pictures.dart';
import 'package:synthiapp/Widgets/app_bar.dart';
import 'package:synthiapp/Widgets/profile_picture_item.dart';
import 'package:synthiapp/config/config.dart';

class SettingsPictures extends StatefulWidget {
  const SettingsPictures() : super();

  @override
  _SettingsPicturesState createState() => _SettingsPicturesState();
}

class _SettingsPicturesState extends State<SettingsPictures> {
  final SettingsPicturesController _controller = SettingsPicturesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: SynthiaAppBar(
        title: "Modifier l'avatar",
        closeIcon: Icons.close,
        returnValue: _controller.model.images
            .where((element) => element.isSelected)
            .first
            .path,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(_controller.model.images.length, (index) {
                final String userPicture =
                    user.data?.photoURL ?? 'assets/avatars/avatar_01.png';
                final String selectedPicutre = _controller.model.images[index].path;

                if (userPicture == selectedPicutre) {
                  return Hero(
                    tag: 'avatar',
                    child: _buildProfilePictureItem(index),
                  );
                }
                return _buildProfilePictureItem(index);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Material _buildProfilePictureItem(int index) {
    return Material(
      type: MaterialType.transparency,
      child: ProfilePictureItem(
        profileImage: _controller.model.images[index],
        onPressed: _controller.model.updating ? null : () => _controller.updateSelection(index, this),
      ),
    );
  }
}
