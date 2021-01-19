import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  LocalNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings();
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String title, String body) async {
    final android = AndroidNotificationDetails(
    'channel id', 'channel name', 'channel description',
    priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);

    await flutterLocalNotificationsPlugin.show(0, title, body, platform);
  }
}
