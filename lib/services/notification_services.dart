/*
import 'dart:io';

import 'package:cgp_driver_app/app/modules/tripRequest/controllers/trip_request_controller.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;

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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User granted provisional permission");
      }
    } else {
      if (kDebugMode) {
        print("User denied permission");
      }
    }
  }

  void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
          handleMessageClick(context, message);
        });
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      showBadge: true,
      importance: Importance.high,
      description: 'This channel is used for important notifications.', // description
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: "channel description",
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
      fullScreenIntent: true,
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  static Future<void> handleMessageClick(BuildContext context, RemoteMessage message) async {
    print("Notification Data: ${message.data}");

    if (true/*message.data["type"] == "delivery_request"*/) {
      String requestId = message.data["requestId"];
      String notificationId = message.data["id"];
      Get.put(TripRequestController());
      Get.find<TripRequestController>().getTripDetails(requestId: requestId,notificationId:notificationId);
      Get.toNamed(Routes.TRIP_REQUEST);
    }
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessageClick(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
*/

/*

import 'dart:io';
import 'package:cgp_driver_app/app/modules/tripRequest/views/trip_request_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../app/modules/notifications/controllers/notifications_controller.dart';
import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;

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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User granted provisional permission");
      }
    } else {
      if (kDebugMode) {
        print("User denied permission");
      }
    }
  }

  void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handelMessageClick(context, message);
      },
    );
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      showBadge: true,
      importance: Importance.high,
      description: 'This channel is used for important notifications.', // description
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
      fullScreenIntent: true,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      print("Notification received");
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  static Future<void> handelMessageClick(BuildContext context, RemoteMessage message) async {

   print(message.toString());
    /*if (true) {
      String requestId = message.data["requestId"];
      String notificationId = message.data["id"];
      Get.put(TripRequestController());
      Get.find<TripRequestController>().getTripDetails(requestId: requestId,notificationId:notificationId);
     // Get.toNamed(Routes.TRIP_REQUEST);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  TripRequestView()),
      );
    }*/

   print("Message Data: ${message.data}");
   Get.put(NotificationsController());
   Get.find<NotificationsController>().getNotifications();
   Get.toNamed(Routes.NOTIFICATIONS);

  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handelMessageClick(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handelMessageClick(context, event);
    });
  }

  Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

*/

//Notification with dialog

/*

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../app/modules/notifications/controllers/notifications_controller.dart';
import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;

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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User granted provisional permission");
      }
    } else {
      if (kDebugMode) {
        print("User denied permission");
      }
    }
  }

  void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessageClick(context, message);
      },
    );
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCallDialog(message.notification?.title ?? '', message.notification?.body ?? '');
        });
      } else {
        showNotification(message);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCallDialog(message.notification?.title ?? '', message.notification?.body ?? '');
        });
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      showBadge: true,
      importance: Importance.high,
      description: 'This channel is used for important notifications.', // description
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
      fullScreenIntent: true,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      showCallDialog(message.notification?.title ?? '', message.notification?.body ?? '');
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  static Future<void> handleMessageClick(BuildContext context, RemoteMessage message) async {
    print(message.toString());
    print("Message Data: ${message.data}");
    Get.put(NotificationsController());
    Get.find<NotificationsController>().getNotifications();
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessageClick(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }

  Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showCallDialog(String title, String description) {
    Get.defaultDialog(
      title: title,
      content: Text(description),
      actions: [
        TextButton(
          onPressed: () {
            // Handle Accept action
            Get.back();
          },
          child: Text('Accept'),
        ),
        TextButton(
          onPressed: () {
            // Handle Decline action
            Get.back();
          },
          child: Text('Decline'),
        ),
      ],
    );
  }
}

*/

//Notification with snackbar

/*
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../app/modules/notifications/controllers/notifications_controller.dart';
import '../app/routes/app_pages.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;

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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User granted provisional permission");
      }
    } else {
      if (kDebugMode) {
        print("User denied permission");
      }
    }
  }

  void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackbar(message.notification?.title ?? '', message.notification?.body ?? '');
          });
        } else {
          // App is in background, show full notification
          showNotification(message);
        }
      } else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackbar(message.notification?.title ?? '', message.notification?.body ?? '');
          });
        } else {
          // App is in background, show full notification
          showNotification(message);
        }
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      showBadge: true,
      importance: Importance.high,
      description: 'This channel is used for important notifications.', // description
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
      fullScreenIntent: true,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  static Future<void> handleMessageClick(BuildContext context, RemoteMessage message) async {
    print(message.toString());
    print("Message Data: ${message.data}");
    Get.put(NotificationsController());
    Get.find<NotificationsController>().getNotifications();
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessageClick(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }

  Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 30),
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      mainButton: TextButton(
        onPressed: () {},
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                // Handle Accept action
                Get.back();
              },
              child: Text('Accept', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                // Handle Decline action
                Get.back();
              },
              child: Text('Decline', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}*/


/*
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../app/modules/notifications/controllers/notifications_controller.dart';
import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';
import '../common_widgets/custom_animated_button.dart';
import '../other_controllers/count_down_controller.dart';

class NotificationServices {


  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  late AudioPlayer audioPlayer = AudioPlayer();

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

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            playSound();
            showSnackBar(
                message.notification?.title ?? '',
                message.notification?.body ?? '',
                message.data["requestId"],
                message.data["id"]);
          });
        } else {
          // App is in background, show full notification
          showNotification(message);
        }
      } else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
                message.notification?.title ?? '',
                message.notification?.body ?? '',
                message.data["requestId"],
                message.data["id"]);
            playSound();
          });
        } else {
          // App is in background, show full notification
          showNotification(message);
        }
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      showBadge: true,
      importance: Importance.high,
      description:
          'This channel is used for important notifications.', // description
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
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    Get.put(NotificationsController());
    Get.find<NotificationsController>().getNotifications();
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessageClick(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }

  Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  void showSnackBar(
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
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black.withOpacity(.5),
        duration: const Duration(seconds: 15),
        icon: Icon(Icons.navigation_sharp,color: Colors.white,),
      ),
      backgroundColor: AppColors.shadowColor,
      colorText: AppColors.primaryColor,
      duration: const Duration(seconds: 15),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
     /* icon: Obx(() {
        final countdownController = Get.find<CountdownController>();
        return CircularProgressIndicator(
          value: countdownController.progressValue.value,
          semanticsLabel:countdownController.progressValue.value.toString() ,
          strokeWidth: 4.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          backgroundColor: Colors.grey.withOpacity(0.5),
        );
      }),*/
    );
  }



  void playSound() async {
    try {
      // Play sound
      audioPlayer = AudioPlayer();

      audioPlayer.setSourceAsset("sound.mp3");

      audioPlayer.resume();
      // await audioPlayer.play(AssetSource('sound.mp3'),volume: 100,mode: PlayerMode.mediaPlayer);

      await Vibration.vibrate(duration: 500);
      // Vibrate (if available on the device)
      // Vibrate for 500 milliseconds
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}

 */



/*

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../app/modules/notifications/controllers/notifications_controller.dart';
import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';
import '../common_widgets/custom_animated_button.dart';
import '../other_controllers/count_down_controller.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  late AudioPlayer audioPlayer = AudioPlayer();

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

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            playSound();
            showSnackBar(
                message.notification?.title ?? '',
                message.notification?.body ?? '',
                message.data["requestId"],
                message.data["id"]);
          });
        } else {
          // App is in background, show full notification
          showNotification(message);
        }
      } else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
                message.notification?.title ?? '',
                message.notification?.body ?? '',
                message.data["requestId"],
                message.data["id"]);
            playSound();
          });
        } else {
          // App is in background, show full notification
          showNotification(message);
        }
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      channelDescription: 'This channel is used for important notifications.', // description
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
      fullScreenIntent: true,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    Get.put(NotificationsController());
    Get.find<NotificationsController>().getNotifications();
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessageClick(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }

  Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showSnackBar(
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
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black.withOpacity(.5),
        duration: const Duration(seconds: 15),
        icon: Icon(Icons.navigation_sharp, color: Colors.white),
      ),
      backgroundColor: AppColors.shadowColor,
      colorText: AppColors.primaryColor,
      duration: const Duration(seconds: 15),
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  void playSound() async {
    try {
      // Play sound
      audioPlayer = AudioPlayer();

      audioPlayer.setSourceAsset("sound.mp3");

      audioPlayer.resume();
      // await audioPlayer.play(AssetSource('sound.mp3'),volume: 100,mode: PlayerMode.mediaPlayer);

      await Vibration.vibrate(duration: 500);
      // Vibrate (if available on the device)
      // Vibrate for 500 milliseconds
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
*/


/*


import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';
import '../common_widgets/custom_animated_button.dart';
import '../other_controllers/count_down_controller.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  late AudioPlayer audioPlayer = AudioPlayer();

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

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> createNotificationChannel() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            playSound();
            showSnackBar(
                message.notification?.title ?? '',
                message.notification?.body ?? '',
                message.data["requestId"],
                message.data["id"]);
          });
        } else {
          // App is in background, show full notification
          showNotification(message);
        }
      } else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
                message.notification?.title ?? '',
                message.notification?.body ?? '',
                message.data["requestId"],
                message.data["id"]);
            playSound();
          });
        } else {
          // App is in background, show full notification
          showNotification(message);
        }
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
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
    );

    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
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
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    /*Get.put(NotificationsController());
    Get.find<NotificationsController>().getNotifications();
    Get.toNamed(Routes.NOTIFICATIONS);*/
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      //handleMessageClick(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }

  Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showSnackBar(
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
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black.withOpacity(.5),
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

  void playSound() async {
    try {
      // Play sound
      audioPlayer = AudioPlayer();

      audioPlayer.setSourceAsset("sound.mp3");

      audioPlayer.resume();
      // await audioPlayer.play(AssetSource('sound.mp3'),volume: 100,mode: PlayerMode.mediaPlayer);

      await Vibration.vibrate(duration: 500);
      // Vibrate (if available on the device)
      // Vibrate for 500 milliseconds
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}

*/



/*
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import '../other_controllers/count_down_controller.dart';
import '../common_widgets/custom_animated_button.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
 static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
 static  AudioPlayer audioPlayer = AudioPlayer();
 static const storage = FlutterSecureStorage();

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
        if (response.payload != null) {
          handleForegroundNotification(context);
        }
      },
    );
  }

  Future<void> createNotificationChannel() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
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
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            playSound();
            showSnackBar(
                message.notification?.title ?? '',
                message.notification?.body ?? '',
                message.data["requestId"],
                message.data["id"]);
          });
        } else {
          // App is in background, show full notification
         // showNotification(message);
        }
      } else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
                message.notification?.title ?? '',
                message.notification?.body ?? '',
                message.data["requestId"],
                message.data["id"]);
            playSound();
          });
        } else {
          // App is in background, show full notification
         // showNotification(message);
        }
      }
    });
  }

 static Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
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
    );

    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
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

    // Save data to secure storage
    await storage.write(key: 'requestId', value: message.data['requestId']);
    await storage.write(key: 'notificationId', value: message.data['id']);
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("FCM Token:$token");
    return token!;

  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    Get.put(TripRequestController());
    Get.find<TripRequestController>()
        .getTripDetails(requestId: message.data['requestId'], notificationId: message.data['id']);
    Get.toNamed(Routes.TRIP_REQUEST);
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessageClick(context, initialMessage);
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

 static void handleForegroundNotification(BuildContext context) async {
    String? requestId = await storage.read(key: 'requestId');
    String? notificationId = await storage.read(key: 'notificationId');

    if (requestId != null && notificationId != null) {
      Get.find<TripRequestController>()
          .getTripDetails(requestId: requestId, notificationId: notificationId);
      Get.toNamed(Routes.TRIP_REQUEST);

      // Clear the saved data
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
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black.withOpacity(.5),
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
    try {
      audioPlayer = AudioPlayer();
      await audioPlayer.setSourceAsset("sound.mp3");
      await audioPlayer.resume();
      await Vibration.vibrate(duration: 500);
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}

*/

// working fine


/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import '../other_controllers/count_down_controller.dart';
import '../common_widgets/custom_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  static AudioPlayer audioPlayer = AudioPlayer();
  static const storage = FlutterSecureStorage();

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
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        if (response.payload != null) {
          handleForegroundNotification(context);
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
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            playSound();
            showSnackBar(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.data["requestId"],
              message.data["id"],
            );
          });
        } else {
          // App is in background, show full notification
          showNotificationWithoutContext(message);
        }
      } else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.data["requestId"],
              message.data["id"],
            );
            playSound();
          });
        } else {
          // App is in background, show full notification
          showNotificationWithoutContext(message);
        }
      }
    });
  }

  static Future<void> showNotificationWithoutContext(
      RemoteMessage message) async {
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
    );

    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Check if notification with the same ID is already displayed
    String? storedRequestId = await storage.read(key: 'requestId');
    String? storedNotificationId = await storage.read(key: 'notificationId');
    if (storedRequestId == message.data['requestId'] &&
        storedNotificationId == message.data['id']) {
      print('Notification already shown');
      return;
    }

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['requestId'],
    );

    // Save data to secure storage
    await storage.write(key: 'requestId', value: message.data['requestId']);
    await storage.write(key: 'notificationId', value: message.data['id']);
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("FCM Token:$token");
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    Get.put(TripRequestController());
    Get.find<TripRequestController>().getTripDetails(
        requestId: message.data['requestId'],
        notificationId: message.data['id']);
    Get.toNamed(Routes.TRIP_REQUEST);
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessageClick(context, initialMessage);
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

  static void handleForegroundNotification(BuildContext context) async {
    String? requestId = await storage.read(key: 'requestId');
    String? notificationId = await storage.read(key: 'notificationId');

    if (requestId != null && notificationId != null) {
      Get.find<TripRequestController>()
          .getTripDetails(requestId: requestId, notificationId: notificationId);
      Get.toNamed(Routes.TRIP_REQUEST);

      // Clear the saved data
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
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black.withOpacity(.5),
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
    try {
      audioPlayer = AudioPlayer();
      await audioPlayer.setSourceAsset("sound.mp3");
      await audioPlayer.resume();
      await Vibration.vibrate(duration: 500);
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}


*/



/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import '../other_controllers/count_down_controller.dart';
import '../common_widgets/custom_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  static AudioPlayer audioPlayer = AudioPlayer();
  static const storage = FlutterSecureStorage();

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
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        if (response.payload != null) {
          handleForegroundNotification(context);
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
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            playSound();
            showSnackBar(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.data["requestId"],
              message.data["id"],
            );
          });
        } else {
          // App is in background, show full notification
          showNotificationWithoutContext(message);
        }
      } else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.data["requestId"],
              message.data["id"],
            );
            playSound();
          });
        } else {
          // App is in background, show full notification
          showNotificationWithoutContext(message);
        }
      }
    });
  }

  static Future<void> showNotificationWithoutContext(
      RemoteMessage message) async {
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
    );

    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Check if notification with the same ID is already displayed
    String? storedRequestId = await storage.read(key: 'requestId');
    String? storedNotificationId = await storage.read(key: 'notificationId');
    if (storedRequestId == message.data['requestId'] &&
        storedNotificationId == message.data['id']) {
      print('Notification already shown');
      return;
    }

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['requestId'],
    );

    // Save data to secure storage
    await storage.write(key: 'requestId', value: message.data['requestId']);
    await storage.write(key: 'notificationId', value: message.data['id']);
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("FCM Token:$token");
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    Get.put(TripRequestController());
    Get.find<TripRequestController>().getTripDetails(
        requestId: message.data['requestId'],
        notificationId: message.data['id']);
    Get.toNamed(Routes.TRIP_REQUEST);
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Handle initial message
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

  static void handleForegroundNotification(BuildContext context) async {
    String? requestId = await storage.read(key: 'requestId');
    String? notificationId = await storage.read(key: 'notificationId');

    if (requestId != null && notificationId != null) {
      Get.find<TripRequestController>()
          .getTripDetails(requestId: requestId, notificationId: notificationId);
      Get.toNamed(Routes.TRIP_REQUEST);

      // Clear the saved data
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
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black.withOpacity(.5),
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
    try {
      audioPlayer = AudioPlayer();
      await audioPlayer.setSourceAsset("sound.mp3");
      await audioPlayer.resume();
      await Vibration.vibrate(duration: 500);
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}

*/


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../app/modules/tripRequest/controllers/trip_request_controller.dart';
import '../app/routes/app_pages.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import '../other_controllers/count_down_controller.dart';
import '../common_widgets/custom_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;
  static AudioPlayer audioPlayer = AudioPlayer();
  static const storage = FlutterSecureStorage();

 static int notificationCount = 0;

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
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        if (response.payload != null) {
          handleForegroundNotification(context);
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
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            playSound();
            showSnackBar(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.data["requestId"],
              message.data["id"],
            );
          });
        } else {
          // App is in background, show full notification
          showNotificationWithoutContext(message);
        }
      } else {
        if (Get.isSnackbarOpen == false) {
          // App is in foreground, only show Snackbar and play sound
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.data["requestId"],
              message.data["id"],
            );
            playSound();
          });
        } else {
          // App is in background, show full notification
          showNotificationWithoutContext(message);
        }
      }
    });
  }

  static Future<void> showNotificationWithoutContext(
      RemoteMessage message) async {
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
      sound: 'sound.wav', // Custom sound
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Check if notification with the same ID is already displayed
    String? storedRequestId = await storage.read(key: 'requestId');
    String? storedNotificationId = await storage.read(key: 'notificationId');
    if (storedRequestId == message.data['requestId'] &&
        storedNotificationId == message.data['id']) {
      print('Notification already shown');
      return;
    }

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['requestId'],
    );

    // Save data to secure storage
    await storage.write(key: 'requestId', value: message.data['requestId']);
    await storage.write(key: 'notificationId', value: message.data['id']);

    // Update notification count
    notificationCount++;
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("FCM Token:$token");
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    Get.put(TripRequestController());
    Get.find<TripRequestController>().getTripDetails(
        requestId: message.data['requestId'],
        notificationId: message.data['id']);
    Get.toNamed(Routes.TRIP_REQUEST);
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Handle initial message
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

  static void handleForegroundNotification(BuildContext context) async {
    String? requestId = await storage.read(key: 'requestId');
    String? notificationId = await storage.read(key: 'notificationId');

    if (requestId != null && notificationId != null) {
      Get.find<TripRequestController>()
          .getTripDetails(requestId: requestId, notificationId: notificationId);
      Get.toNamed(Routes.TRIP_REQUEST);

      // Clear the saved data
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
        },
        text: "View",
        startColor: Colors.white,
        endColor: Colors.black.withOpacity(.5),
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
    try {
      audioPlayer = AudioPlayer();
      await audioPlayer.setSourceAsset("sound.mp3");
      await audioPlayer.resume();
      await Vibration.vibrate(duration: 500);
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
