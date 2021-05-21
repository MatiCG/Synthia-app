import 'package:flutter/material.dart';

class BuildAvatar extends StatelessWidget {
  final Function()? onPressed;
  final String? path;
  final bool isRounded;

  BuildAvatar({
    required this.path,
    this.onPressed,
    this.isRounded = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25.0),
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isRounded ? 50.0 : 15.0),
        child: Image(
          image: _imageProvider(),
          height: MediaQuery.of(context).size.width * 0.15,
          width: MediaQuery.of(context).size.width * 0.15,
        ),
      ),
    );
  }

  _imageProvider() {
    if (path == null) return AssetImage('assets/avatars/avatar_01.png');
    if (path!.contains('http') || path!.contains('https')) {
      return NetworkImage(path!);
    }
    return AssetImage(path!);
  }
}
