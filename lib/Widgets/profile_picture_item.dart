import 'package:flutter/material.dart';
import 'package:synthiapp/Models/settings/pictures.dart';

class ProfilePictureItem extends StatelessWidget {
  const ProfilePictureItem({
    required this.profileImage,
    required this.onPressed,
  }) : super();

  final ProfileImage profileImage;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: profileImage.isSelected ? 5 : 0,
              color: Theme.of(context).accentColor,
            ),
          ),
          height: MediaQuery.of(context).size.width * 0.2,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Image.asset(profileImage.path),
        ),
      ),
    );
  }
}
