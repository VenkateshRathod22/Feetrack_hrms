import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/controllers/basic_controller.dart';
import 'package:vlr/firebase_options.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final basicController = Get.find<BasicController>();

  static Future<void> initialize() async {
    // 1. Request Firebase Permissions (Required for Android 13+ & iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted notification permissions');

      // 2. Initialize Local Notifications for Foreground Banners
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      const initSettings =
          InitializationSettings(android: androidInit, iOS: iosInit);
      try {
        await _localNotifications.initialize(

          onDidReceiveNotificationResponse: (NotificationResponse response) {
            log("Notification tapped: ${response.payload}");
          }, settings: initSettings,
        );
      } catch (e, s) {
        log('Local notifications init failed: $e\n$s');
      }

      // 3. Create a High Importance Channel (Forces banner to pop down)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'tpipay_payment_channel', // id
        'Payment Notifications', // title
        description: 'Used for TpiPay Sound Box announcements',
        importance: Importance.max,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 4. Get and log the Token
      await getFCMToken();

      // 5. Listen for Messages while the App is OPEN (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log("Foreground Message: ${message.data}");

        // Show the visual banner
        _showLocalNotification(message, channel);

        // Trigger the Sound Box voice
      });

      // 6. Set the Background/Terminated Handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }
  }

  static Future<String?> getFCMToken() async {
    try {
      String? token = await _messaging.getToken();

      log("-----------------------------------------");
      log("FCM TOKEN: $token");
      log("-----------------------------------------");
      Get.find<AuthController>().saveFMCToken(token ?? "");

      return token ?? "";
    } catch (e) {
      log("Error getting FCM token: $e");
      return null;
    }
  }

  static void _showLocalNotification(
      RemoteMessage message, AndroidNotificationChannel channel) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }
}

// Global Background Handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 🔴 CRITICAL: Wake up the native plugins for the background isolate
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  // 🔴 THE MAGIC FIX: KEEP THE ISOLATE ALIVE
  // We must force Android to keep the background app running for an extra 6 seconds.
  // This gives the Azure API time to download the audio, and the speaker time to finish saying the whole sentence before Android kills the app!
  log("Background handler finished and closing safely.");
}
