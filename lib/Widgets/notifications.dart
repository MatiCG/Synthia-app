import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:synthiaapp/config.dart';

class PushNotificationsHandler {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  PushNotificationsHandler() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings();
    initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification({
    String title,
    String body,
  }) {
    final android = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.show(0, title, body, platform);
  }

  Future<void> init() async {
    if (!_initialized) {
      // For IOS - request permission first.
      _firebaseMessaging.requestPermission();
      // Subscribe user to notification chanel notifications
      _firebaseMessaging.subscribeToTopic('synthIA');
      // Display notification if receive during app close
      _firebaseMessaging.getInitialMessage().then((RemoteMessage message) {
        if (message == null) {
          return;
        }
        this.showNotification(
          title: message.notification.title,
          body: message.notification.body,
        );
      });
      // Stream to get every notifification event
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message == null) {
          return;
        }
        this.showNotification(
          title: message.notification.title,
          body: message.notification.body,
        );
      });
      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      // Save user token
      if (token != null) {
        auth.notificationToken = token;
      }
      _initialized = true;
    }
  }
}
