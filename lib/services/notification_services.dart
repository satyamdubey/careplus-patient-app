import 'dart:io';

import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/controller/notification_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PushNotificationService {
  static final PushNotificationService _pushNotificationService =
      PushNotificationService._internal();

  factory PushNotificationService() {
    return _pushNotificationService;
  }

  PushNotificationService._internal();

  late final String? token;

  // initialisation of push notification service
  Future<void> initialize() async {
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
      if (Platform.isAndroid) {
        _messaging.subscribeToTopic('android');
      }

      // send notification to ios users
      if (Platform.isIOS) {
        _messaging.subscribeToTopic('ios');
      }

      // send notification to all users of app
      _messaging.subscribeToTopic('careplus');

      // handle the notification when app is in foreground state
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleMessage(message, appForeground: true);
      });

      // For handling notification when the app is in background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessage(message, appBackground: true);
      });

      // handle the notification when app is terminated state
      RemoteMessage? message =
          await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        _handleMessage(message, appTerminated: true);
      }
    }
  }

  void _handleMessage(
    RemoteMessage message, {
    bool appForeground = false,
    bool appBackground = false,
    bool appTerminated = false,
  }) {
    final notificationController = Get.find<NotificationController>();
    if (appForeground) {
      notificationController.getAllNotifications();
      Get.showSnackbar(
        GetSnackBar(
          title: "Notification",
          icon: Image.asset(carePlusLogo),
          snackPosition: SnackPosition.TOP,
          message: message.notification!.title!,
          duration: const Duration(seconds: 5),
        ),
      );
    } else if (appBackground) {
      notificationController.getAllNotifications();
    } else if (appTerminated) {}
  }
}
