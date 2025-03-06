


import 'dart:async';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';
import '../common_widgets/custom_animated_button.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import '../other_controllers/count_down_controller.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  static AudioPlayer audioPlayer = AudioPlayer();
  static const storage = FlutterSecureStorage();
  static Timer? soundTimer;

  static int notificationCount = 0;
  static bool isCallEnded = false; // Add a flag to manage call state

  NotificationServices() {

    _initCallKit(); // Initialize the CallKit listener
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User granted permission");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User granted provisional permission");
      }
    } else {
      if (kDebugMode) {
        print("User denied permission");
      }
    }
  }

  static void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print(response);

        if (response.payload != null) {
         handleForegroundNotification(context,response);
        }
      },
    );
  }

  Future<void> createNotificationChannel() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.data);
      if (Platform.isIOS) {
        foregroundMessage();
      }


      if (Platform.isAndroid||Platform.isIOS) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false && message.data["requestId"] != null) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (message.data["id"] != null) playSound();
            showSnackBar(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.data["requestId"],
              message.data["id"],
            );
          });
        } else {
          // App is in background, show full notification
          if (message.data['id'] != null) {
            showNotificationWithoutContext(message);
          }
        }
      }
      else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.data["requestId"],
              message.data["id"],
            );
            if (message.data["id"] != null) playSound();
          });
        } else {
          // App is in background, show full notification
          showNotificationWithoutContext(message);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.data);
    });

  }



  static Future<void> showNotificationWithoutContext(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
      fullScreenIntent: true,
      styleInformation: InboxStyleInformation(
        [], // Add the messages here
        contentTitle: 'You have ${notificationCount + 1} new messages',
        summaryText: 'New messages',
      ),
    );

    DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: notificationCount + 1,
     // sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['requestId'],
    );

    notificationCount++;

    showCallScreen(message);
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    if (kDebugMode) {
      print("FCM Token:$token");
    }
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    stopSound();
    FlutterCallkitIncoming.endAllCalls();

    if (message.data['requestId']!=null) {
      Get.put(TripRequestController());
      Get.find<TripRequestController>().getTripDetails(
          requestId: message.data['requestId'],
          notificationId: message.data['id']);
      Get.toNamed(Routes.TRIP_REQUEST);
    }
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data.isNotEmpty) {
        handleMessageClick(context, initialMessage);
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }

  static Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static void handleForegroundNotification(BuildContext context, NotificationResponse response) async {
    String? requestId = await storage.read(key: 'requestId');
    String? notificationId = await storage.read(key: 'notificationId');


    print("requestId:${response.payload}");

    if (requestId != null && notificationId != null) {
      Get.find<TripRequestController>()
          .getTripDetails(requestId: requestId, notificationId: notificationId);
      Get.toNamed(Routes.TRIP_REQUEST);

      await storage.delete(key: 'requestId');
      await storage.delete(key: 'notificationId');
    }
  }



  static void showSnackBar(
      String title, String message, String requestId, String notificationId) {
    Get.put(CountdownController());

    Get.snackbar(
      title,
      '',
      titleText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: title, color: AppColors.primaryColor, size: 14),
          BodyText(text: message),
        ],
      ),
      messageText: AnimatedButtonWithProgress(
        onPressed: () {
          Get.put(TripRequestController());
          Get.find<TripRequestController>().getTripDetails(
              requestId: requestId, notificationId: notificationId);
          Get.toNamed(Routes.TRIP_REQUEST);
          Get.back();
          stopSound();
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black26,
        duration: const Duration(seconds: 15),
        icon: const Icon(Icons.navigation_sharp, color: Colors.white),
      ),
      backgroundColor: AppColors.shadowColor,
      colorText: AppColors.primaryColor,
      duration: const Duration(seconds: 15),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static void playSound() async {
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setSourceAsset("sound_2.mp3");
    await audioPlayer.resume();

    soundTimer = Timer(const Duration(seconds: 15), () {
      stopSound();
    });
  }

  static void stopSound() async {
    await audioPlayer.stop();
    soundTimer?.cancel();
  }


  static Future<void> showCallScreen(RemoteMessage message) async {
    if (message.data["id"] != null && message.data["requestId"] != null) {
      await FlutterCallkitIncoming.showCallkitIncoming(
        CallKitParams(
          id: message.data['id'],
          nameCaller: message.notification?.title ?? 'New Request',
          appName: 'Tradebar',
          // avatar: 'https://example.com/avatar.png',
          handle: 'New Request',
          type: 0,
          // 0 for incoming call
          duration: 15000,
          // 15 seconds
          textAccept: 'View',
          textDecline: 'Dismiss',
          missedCallNotification:
          const NotificationParams(showNotification: false),
          extra: <String, dynamic>{
            'requestId': message.data['requestId'],
            'notification_id': message.data['id'],
          },
          android: const AndroidParams(
              ringtonePath: 'sound_2',
              // Specify the path to the sound file in assets
              isShowLogo: false,
              isShowFullLockedScreen: false),
          ios: const IOSParams(
            ringtonePath:
            'sound_2.mp3', // Specify the path to the sound file in assets
          ),
        ),
      );
    }
  }

  void _initCallKit() {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      if (event != null) {
        switch (event.event) {
          case Event.actionCallAccept:
            _handleCallAccept(event);
            break;
          case Event.actionCallDecline:
            _handleCallDecline(event);
            break;
          case Event.actionCallEnded:
            _handleCallDecline(event);
            break;
          case Event.actionCallToggleGroup:
          default:
            break;
        }
      }
    });
  }

  void _handleCallAccept(CallEvent event) {
    String requestId = event.body["extra"]['requestId'];
    String notificationId = event.body["extra"]['notification_id'];

    // Handle the call accept action
    Get.put(TripRequestController());
    Get.find<TripRequestController>()
        .getTripDetails(requestId: requestId, notificationId: notificationId);
    Get.toNamed(Routes.TRIP_REQUEST);

    // End the call
    FlutterCallkitIncoming.endCall(event.body['id']);
  }

  void _handleCallDecline(CallEvent event) {
    // Ensure call end process is handled only once
    if (!isCallEnded) {
      isCallEnded = true; // Set the flag to true
      FlutterCallkitIncoming.endCall(event.body['id']);
      // Reset the flag after some time to allow future calls
      Timer(const Duration(seconds: 2), () {
        isCallEnded = false;
      });
    }
  }
}


// should use for android


/*import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../../app/routes/app_pages.dart';
import '../../common_widgets/custom_animated_button.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const storage = FlutterSecureStorage();
  static AudioPlayer audioPlayer = AudioPlayer();
  static Timer? soundTimer;
  static int notificationCount = 0;

  NotificationServices() {
    requestNotificationPermission();
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print("Notification Permission: ${settings.authorizationStatus}");
  }

  static void initLocalNotification(BuildContext context,RemoteMessage message) async {
    var initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.payload != null) {
          handleNotificationClick(context,message );
        }
      },
    );
  }

  static Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      print("Foreground Message: ${message.data}");
      showNotificationWithoutContext(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleNotificationClick(context, message.data['requestId'] ?? '');
    });
  }

  static Future<void> showNotificationWithoutContext(RemoteMessage message) async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('sound_2'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['requestId'],
    );

    playSound();
  }

  static Future<void> handleNotificationClick(BuildContext context, RemoteMessage message) async {
    stopSound();
    if (message.data['requestId']!=null) {
      Get.put(TripRequestController());
      Get.find<TripRequestController>().getTripDetails(
          requestId: message.data['requestId'],
          notificationId: message.data['id']);
      Get.toNamed(Routes.TRIP_REQUEST);
    }
  }

  static void playSound() async {
    audioPlayer = AudioPlayer();
    await audioPlayer.setSourceAsset("sound_2.mp3");
    await audioPlayer.resume();
    soundTimer = Timer(Duration(seconds: 15), stopSound);
  }

  static void stopSound() async {
    await audioPlayer.stop();
    soundTimer?.cancel();
  }

  static void showSnackBar(RemoteMessage message) {
    Get.snackbar(
      message.notification?.title??"",
      '',
      titleText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: message.notification?.title??"", color: AppColors.primaryColor, size: 14),
          BodyText(text: message.notification?.body??""),
        ],
      ),
      messageText: AnimatedButtonWithProgress(
        onPressed: () {
          handleNotificationClick(Get.context!, message);
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black26,
        duration: Duration(seconds: 15),
        icon: Icon(Icons.navigation_sharp, color: Colors.white),
      ),
      backgroundColor: AppColors.shadowColor,
      colorText: AppColors.primaryColor,
      duration: Duration(seconds: 15),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}*/


