import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:synthiaapp/config.dart';

class RoundedImagePicker extends StatefulWidget {
  RoundedImagePicker({
    this.imagePath,
  }) : super();

  final String imagePath;

  _RoundedImagePickerState createState() => _RoundedImagePickerState();
}

class _RoundedImagePickerState extends State<RoundedImagePicker> {
  static const String defaultImagePath =
      'https://firebasestorage.googleapis.com/v0/b/synthia-app-eip.appspot.com/o/default_profile_picture.png?alt=media&token=7b35cd9e-41cb-490e-9ed8-c35889d3a48c';
  final ImagePicker _picker = ImagePicker();
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  dynamic image;
  bool uploading = false;

  // Get a picture depending of the source (CAMERA or GALLERY)
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    try {
      var file = File(pickedFile.path);
      await _storage
          .ref('users_profiles_pictures/user_${auth.user.uid}.png')
          .putFile(file);
      setState(() {
        uploading = true;
      });
      String url = await _storage
          .ref('users_profiles_pictures/user_${auth.user.uid}.png')
          .getDownloadURL();
      auth.user.updateProfile(photoURL: url).then((value) {
        setState(() {
          uploading = false;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // build modal content
  Widget buildModalContent() {
    return Container(
      height: 200.0,
      color: Theme.of(context).accentColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              'Choose your profile picture from',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  label: Text(
                    'camera',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  icon: Icon(
                    Icons.camera,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  label: Text(
                    'gallery',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  icon: Icon(
                    Icons.image,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    image = widget.imagePath == null || widget.imagePath.contains('http')
        ? NetworkImage(widget?.imagePath ?? defaultImagePath)
        : FileImage(File(widget.imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => buildModalContent(),
      ),
      child: uploading ?
        CircularProgressIndicator()
        : CircleAvatar(
        radius: 50.0,
        backgroundImage: image,
      ),
    );
  }
}
