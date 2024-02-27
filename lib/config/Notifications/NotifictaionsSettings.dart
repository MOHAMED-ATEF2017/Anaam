import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../controller/UserController.dart';



Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  NotificationsSettings _notifications = NotificationsSettings();
  _notifications.showNotifications((message.notification?.title)!,(message.notification?.body)!);
}

void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) async {
  if (kDebugMode) {
    print(' on local background');
  }

  try {
    // final payloadData = json.decode(payload!);
    // final todoRemoteDataSource = sl<TodoRemoteDataSource>();
    // atodoRemoteDataSource.disableNotification(NotificationParams(
    //   atodo: Todo(
    //     task: "",
    //     note: "",
    //     complete: false,
    //     id: payloadData['todoId'],
    //   ),
    // ));
  } catch (_) {}
}

class NotificationsSettings {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  UserController apiController = UserController();

   void FirebaseInit() async {


    // 2. Instantiate Firebase Messaging
     final FirebaseMessaging _messaging = FirebaseMessaging.instance;
     _messaging.getToken().then((token){
       apiController.updateUserFCM(token!);
     });


    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await fcmSubscribeTopic(_messaging, "anaam_notification_topic");

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showNotifications((message.notification?.title)!,(message.notification?.body)!);
      });

      //For handling onBackgroundMessage notifications
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {



      });

    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

   void localInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
      onDidReceiveBackgroundNotificationResponse,
    );
  }



  Future<void> fcmSubscribeTopic(
      FirebaseMessaging messaging, String topicName) async {
    try {
      await messaging.subscribeToTopic(topicName).onError((error, stackTrace) {
        return;
      });
    } catch (_) {
      return;
    }
  }



  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {


    try {
      print(notificationResponse.payload.toString());
      final payloadData = json.decode(notificationResponse.payload.toString()!);
    } catch (_) {}
  }

  final AndroidNotificationDetails _androidNotificationDetails =
  const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> showNotifications(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails),
    );
  }


}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}