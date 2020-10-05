import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synthiaapp/Widgets/SynthiaButton.dart';

class Download extends StatefulWidget {
  Download({
    Key key,
    @required this.fileUrl,
    @required this.fileExtension,
  }) : super(key: key);

  final String fileUrl;
  final String fileExtension;

  @override
  DownloadState createState() => DownloadState();
}

class DownloadState extends State<Download> {
  bool _downloading = false;
  double _progress = 0.0;
  final Dio _dio = Dio();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _downloading == true
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(64.0, 32.0, 64.0, 32.0),
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    progressColor: Colors.green,
                    percent: 1 * _progress / 100,
                    center: Text('${_progress.round().toString()}%'),
                  ),
                ),
              )
            : SynthiaButton(
                text: 'Compte Rendu',
                icon: Icons.file_download,
                action: () {
                  _startDownload();
                },
              ));
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Succès' : 'Echec',
        isSuccess
            ? 'Le document à été téléchargé avec succès! Cliquez pour y accéder'
            : 'Une erreur s\'est produite lors du téléchargement du fichier.',
        platform,
        payload: json);
  }

  Future<void> _startDownload() async {
    final String fileName = 'Synthia-CR.${widget.fileExtension}';
    final String dirPath = (await _getPathDirectory()) + fileName;
    final bool permissionsGranted = await _getPermissions();
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    if (permissionsGranted) {
      try {
        final res = await _dio.download(
          widget.fileUrl,
          dirPath,
          onReceiveProgress: (count, total) {
            setState(() {
              _downloading = true;
              _progress = count / total * 100;
            });
          },
        );
        result['isSuccess'] = res.statusCode == 200;
        result['filePath'] = dirPath;
      } catch (err) {
        result['error'] = err.toString();
      } finally {
        await _showNotification(result);
        setState(() {
          _downloading = false;
        });
      }
    } else {
      _showAlertDialog();
    }
  }

  Future<String> _getPathDirectory() async {
    return Platform.isAndroid
        ? '/sdcard/download/'
        : (await getApplicationDocumentsDirectory()).path + '/Documents';
  }

  Future<bool> _getPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  void _showAlertDialog() {
    final alert = Platform.isAndroid
        ? AlertDialog(
            title: Text('Autorisation'),
            content: Text(
                'Vous devez autoriser l\'application à acceder au stockage de votre smartphone.'),
            elevation: 24.0,
            actions: [
              FlatButton(
                child: Text('Annuler'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Paramètres'),
                onPressed: () async {
                  await PermissionHandler().openAppSettings();
                  Navigator.pop(context);
                },
              )
            ],
          )
        : CupertinoAlertDialog(
            title: Text('Autorisation'),
            content: Text(
                'Vous devez autoriser l\'application à acceder au stockage de votre smartphone.'),
            actions: [
              CupertinoDialogAction(
                child: Text('Annuler'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Paramètres'),
                onPressed: () async {
                  await PermissionHandler().openAppSettings();
                  Navigator.pop(context);
                },
              ),
            ],
          );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
