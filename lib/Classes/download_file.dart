import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synthiaapp/Widgets/notifications.dart';

/// This class is use to download a file given a url and notify the user that
/// the file has been downloaded !
class DownloadFile {
  Dio _dio;
  String _fileStoragePath;
  bool _permissions;
  bool isDownloading;
  // ignore: close_sinks
  StreamController<double> _progressController;
  Stream progression;

  DownloadFile() {
    this._progressController = StreamController<double>();
    this.progression = this._progressController.stream;
    this.isDownloading = false;
  }

  /// Configure everything for the class. Need to be call before everything else
  Future<void> init() async {
    _fileStoragePath = await this.getStoragePath();
    _permissions = await getPermissions();
    _dio = Dio();
  }

  /// Starting download of the given file.
  /// [filename] must be the entire file name with extension
  void start(
      {String url, String filename, bool notificationOnFinish = true}) async {
    final Map<String, dynamic> notificationData = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    if (!this._permissions || this._fileStoragePath == null) {
      print(
          'The user didn\'t give his permission to download or you are on the website');
    }
    try {
      final Response res = await this
          ._dio
          .download(url, _fileStoragePath + '/$filename', onReceiveProgress: (count, total) {
            double percent = count / total * 100;
            print('$percent');
            this._progressController.add(percent);
            this.isDownloading = true;
          });
      notificationData['isSuccess'] = res.statusCode == 200;
      notificationData['filePath'] = this._fileStoragePath + '/$filename';
    } catch (error) {
      this.isDownloading = false;
      print('An error occured when downloading the file.' + error.toString());
    } finally {
      this.isDownloading = false;
      if (notificationOnFinish) {
        PushNotificationsHandler notification =
            PushNotificationsHandler(callback: (String json) async {
          if (jsonDecode(json)['isSuccess']) {
            OpenFile.open(jsonDecode(json)['filePath']);
          }
        });
        notification.showNotification(
            title: notificationData['isSuccess'] ? 'Succès' : 'Echec',
            body: notificationData['isSuccess']
                ? 'Le document a été téléchargé avec succès! Cliquez pour y accéder'
                : 'Une erreur s\'est produite lors du téléchargement du fichier.',
            payload: jsonEncode(notificationData));
      }
    }
  }

  /// Get the user permissions for download and save a file on his phone
  Future<bool> getPermissions() async {
    bool permission = await Permission.storage.isGranted;
    if (!permission) {
      try {
        PermissionStatus status = await Permission.storage.request();
        return status.isGranted ? true : false;
      } catch (error) {
        print('An error occured when permission storage is requested !' +
            error.toString());
        return false;
      }
    }
    return true;
  }

  /// Get the directory where the file will be stored
  Future<String> getStoragePath() async {
    return Platform.isAndroid
        ? '/sdcard/download/'
        : Platform.isIOS
            ? (await getApplicationDocumentsDirectory()).path + '/Compte_Rendu'
            : null;
  }

  /// Send the progress of the download in percent
  Stream get progress => progression;
}
