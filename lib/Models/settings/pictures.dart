class ProfileImage {
  final String path;
  bool isSelected;

  ProfileImage({
    required this.path,
    this.isSelected = false,
  });

  set selection(bool selection) => isSelected = selection;
}

class SettingsPicturesModel {
  final String imagePath = 'assets/avatars/avatar';
  List<ProfileImage> images = [];
  bool updating = false;

  SettingsPicturesModel() {
    images = [
      ProfileImage(path: '${imagePath}_01.png'),
      ProfileImage(path: '${imagePath}_02.png'),
      ProfileImage(path: '${imagePath}_03.png'),
      ProfileImage(path: '${imagePath}_04.png'),
      ProfileImage(path: '${imagePath}_05.png'),
      ProfileImage(path: '${imagePath}_06.png'),
      ProfileImage(path: '${imagePath}_07.png'),
      ProfileImage(path: '${imagePath}_08.png'),
      ProfileImage(path: '${imagePath}_09.png'),
      ProfileImage(path: '${imagePath}_10.png'),
      ProfileImage(path: '${imagePath}_11.png'),
      ProfileImage(path: '${imagePath}_12.png'),
      ProfileImage(path: '${imagePath}_13.png'),
      ProfileImage(path: '${imagePath}_14.png'),
      ProfileImage(path: '${imagePath}_15.png'),
      ProfileImage(path: '${imagePath}_16.png'),
      ProfileImage(path: 'assets/avatars/blank.png'),
    ];
  }
}
