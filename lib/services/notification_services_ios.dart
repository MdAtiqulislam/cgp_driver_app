import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationServices.instance.setupFlutterNotifications();
  await NotificationServices.instance.showNotification(message);
}

class NotificationServices {
  NotificationServices._();
  static final NotificationServices instance = NotificationServices._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocationNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPersmission();

    await _setupMessageHandlers();

    //saveTokenToFirestore(FirebaseAuth.instance.currentUser!.uid);

    final token = await _messaging.getToken();
    print('FCM Token: $token');

    subscribeToTopic('all_devices');
  }

  Future<void> _requestPersmission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('Permossion status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocationNotificationsInitialized) {
      return;
    }
    //android
    const channel = AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    //ios setup
    final initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (details) {},
    );
    _isFlutterLocationNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    print(message.toString());

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
              'This channel is used for important notifications.',
              importance: Importance.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            )),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });
    //background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    //opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'order') {
      //open order screen
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('Subscribed to $topic');
  }
}


/*
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationServicesIos.instance.setupFlutterNotifications();
  await NotificationServicesIos.instance.showNotification(message);
}

class NotificationServicesIos {
  NotificationServicesIos._();
  static final NotificationServicesIos instance = NotificationServicesIos._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _setupMessageHandlers();
    await setupFlutterNotifications(); // Initialize local notifications

    final token = await _messaging.getToken();
    print('FCM Token: $token');

    subscribeToTopic('all_devices');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationClick(details.payload);
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    print(message.toString());

    RemoteNotification? notification = message.notification;
    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(), // Send data when clicked
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    _handleNotificationClick(message.data.toString());
  }

  void _handleNotificationClick(String? payload) {
    if (payload == null) return;

    print("Notification clicked with payload: $payload");

    // Extract data and navigate based on notification type
    final Map<String, dynamic> data = _parsePayload(payload);
    if (data['type'] == 'order') {
      // Navigate to order screen
      print("Navigating to Order Screen...");
    }
  }

  Map<String, dynamic> _parsePayload(String payload) {
    try {
      return Map<String, dynamic>.from(
          payload.isNotEmpty ? jsonDecode(payload) : {});
    } catch (e) {
      print("Error parsing payload: $e");
      return {};
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('Subscribed to $topic');
  }

  Future<String> getDeviceToken() async {
    String? token = await _messaging.getToken();
    if (kDebugMode) {
      print("FCM Token:$token");
    }
    return token!;
  }
}*/
