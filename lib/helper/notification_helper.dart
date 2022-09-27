import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationService {

  static late final String? token;

  // initialisation of push notification service
  static Future<void> initialize() async {

    // getting firebase messaging instance
    FirebaseMessaging _messaging = FirebaseMessaging.instance;

    // getting token for the device
    token = await _messaging.getToken();
    print('notification_token: $token');

    // requesting permissions from user for notifications
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // if permitted for receiving notifications
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {

      // send notification to android users
      if(Platform.isAndroid){
        _messaging.subscribeToTopic('android');
      }

      // send notification to ios users
      if(Platform.isIOS){
        _messaging.subscribeToTopic('ios');
      }

      // send notification to all users of app
      _messaging.subscribeToTopic('nectar-dating-app');

      // handle the notification when app is in foreground state
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleMessage(message, appForeground: true);
      });

      // For handling notification when the app is in background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessage(message, appBackground: true);
      });

      // handle the notification when app is terminated state
      RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        _handleMessage(message, appTerminated: true);
      }
    }
  }

  static void _handleMessage(
      RemoteMessage message, {
        bool appForeground = false,
        bool appBackground = false,
        bool appTerminated = false
      }) {
    if (appForeground) {
      _showPushNotification(message);
    } else if (appBackground) {
      Get.offAllNamed(message.data['route']);
    } else if (appTerminated) {
      // do nothing, works fine
    }
  }

  static _showPushNotification(RemoteMessage message) {
    return showSimpleNotification(
      Text(message.notification!.title!),
      background: Colors.white,
      leading: const Icon(Icons.notifications),
      subtitle: Text(message.notification!.body!),
      duration: const Duration(seconds: 5),
    );
  }

}

