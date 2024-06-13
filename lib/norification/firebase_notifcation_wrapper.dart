import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/db/shared_pref_wrapper.dart';

import '../api/api_wrapper.dart';
import '../background_task/background_location.dart';
import '../utils/ui_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.data.toString()}');
  SharedPrefWrapper.instance.saveBgNotification(message.data);
}

class FirebasePushNotificationWrapper {
  static final FirebasePushNotificationWrapper _instance =
      FirebasePushNotificationWrapper._internal();

  static void init() {
    _instance.initNotification();
  }

  static FirebasePushNotificationWrapper getInstance() {
    return _instance;
  }

  factory FirebasePushNotificationWrapper() {
    return _instance;
  }

  FirebasePushNotificationWrapper._internal();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsInitialized = false;

  void initNotification() async {
    print("init notification");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("onMessageOpenedApp");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');

      print('Message data: ${message.data}');
      BackgroundLocationWrapper.instance.startLiveRide();
      await SharedPrefWrapper.instance.saveBgNotification(message.data);
      checkAndOpenNotification(navigatorKey.currentContext!);
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    uploadTokenToServer();
  }

  Future<void> setupFlutterNotifications() async {
    print("setupFlutterNotifications");
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  void uploadTokenToServer() async {
    if (Authentication.isLoggedIn()) {
      print("fetch token from firebase");
      var token = await getFcmToken();
      print("token from firebase $token");
      if (token != null) uploadFcm(token);
    }
  }

  getFcmToken() async {
    return FirebaseMessaging.instance.getToken();
  }
}
