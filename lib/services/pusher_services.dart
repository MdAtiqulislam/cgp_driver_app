/*
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app/modules/messaging/controllers/messaging_controller.dart';
import '../models/message_data_model.dart';
import '../models/message_model.dart';

class PusherService extends GetxService {
  late PusherClient pusher;
  late Channel messagingChannel;
  late Channel notificationChannel;
  final String uid;
  final AudioPlayer audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  PusherService(this.uid);

  @override
  void onInit() {
    super.onInit();
    initPusher();
    initLocalNotification();

    print("Pusher service is called $uid");
  }

  void initPusher() {

    PusherOptions options = const PusherOptions(
      cluster: 'ap2',
      encrypted: true,
    );

    pusher = PusherClient(
      'd6d77ae2db8ea3a88804',
      options,
      autoConnect: false,
    );

    pusher.connect();

    pusher.onConnectionStateChange((state) {


      if (state?.currentState == 'disconnected') {
        _handleDisconnection();
      }
    });

    pusher.onConnectionError((error) {
      // Handle error if needed
      print("${error?.message}");
    });

    // Subscribe to the messaging channel
    messagingChannel = pusher.subscribe('messages.$uid');
    messagingChannel.bind('App\\Events\\NewMessageEvent', (event) {
      final data = event?.data;

      print("Message data:$uid");

      if (data != null) {
        try {
          var jsonData = json.decode(data);
          var newMessage = MessageModel.fromJson(jsonData);
          Get.find<MessagingController>().messages.add(newMessage.message ?? MessageDataModel());

          // Play notification sound
          _playNotificationSound();

          // Show notification if user is not active in chat
          if (!_isUserActiveInChat()) {
            _showLocalNotification(newMessage.message);
          }
        } catch (e) {
          // Handle error if needed
        }
      }
    });

    // Subscribe to the notifications channel
    notificationChannel = pusher.subscribe('messages-notifications.$uid');
    notificationChannel.bind('App\\Events\\NewMessageEvent', (event) {
      final data = event?.data;
      if (data != null) {
        try {
          var jsonData = json.decode(data);
          var newMessage = MessageModel.fromJson(jsonData);

          // Show notification if user is not active in chat
          if (!_isUserActiveInChat()) {
            _showLocalNotification(newMessage.message);
          }
        } catch (e) {
          // Handle error if needed
        }
      }
    });
  }

  bool _isUserActiveInChat() {
     return Get.currentRoute == Routes.MESSAGING;
  }

  void _showLocalNotification(MessageDataModel? message) async {



    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'high_importance_channel_message',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'New message from Customer',
      message?.message,
      platformChannelSpecifics,
      payload: jsonEncode(message),
    );
  }

  void initLocalNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }

  void _handleDisconnection() {
    Future.delayed(const Duration(seconds: 5), () {
      pusher.connect();
    });
  }

  void _playNotificationSound() {
    audioPlayer.play(AssetSource('notification_sound.wav'), volume: .1);
  }

  @override
  void onClose() {
    pusher.disconnect();
    super.onClose();
  }


  Future<void> onSelectNotification(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      // Parse the payload
      Get.put(MessagingController());
      Get.find<MessagingController>().loadPreviousMessage();
      Get.toNamed(Routes.MESSAGING);

    }
  }

}

 */
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app/modules/messaging/controllers/messaging_controller.dart';
import '../models/message_data_model.dart';
import '../models/message_model.dart';

class PusherService extends GetxService {
  late PusherClient pusher;
  late Channel messagingChannel;
  late Channel notificationChannel;
  final String uid;
  final AudioPlayer audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  PusherService(this.uid);

  @override
  void onInit() {
    super.onInit();
    initPusher();
    initLocalNotification();
  }

  void initPusher() {
    PusherOptions options = const PusherOptions(
      cluster: 'ap2',
      encrypted: true,
    );

    pusher = PusherClient(
      'd6d77ae2db8ea3a88804',
      options,
      autoConnect: false,
    );

    pusher.connect();

    pusher.onConnectionStateChange((state) {
      if (state?.currentState == 'disconnected') {
        _handleDisconnection();
      }
    });

    pusher.onConnectionError((error) {
      print("${error?.message}");
    });

    // Subscribe to the messaging channel
    messagingChannel = pusher.subscribe('messages.$uid');
    messagingChannel.bind('App\\Events\\NewMessageEvent', (event) {
      final data = event?.data;
      if (data != null) {
        try {
          var jsonData = json.decode(data);
          var newMessage = MessageModel.fromJson(jsonData);
        if((newMessage.message?.message)!=null){
          Get.find<MessagingController>().messages.add(newMessage.message ?? MessageDataModel());
          // Play notification sound
          _playNotificationSound();

          // Show notification if user is not active in chat
          if (!_isUserActiveInChat()) {
            _showLocalNotification(newMessage.message);
          }
        }
        } catch (e) {
          print("Error processing message: $e");
        }
      }
    });

    // Subscribe to the notifications channel
    notificationChannel = pusher.subscribe('messages-notifications.$uid');
    notificationChannel.bind('App\\Events\\NewMessageEvent', (event) {
      final data = event?.data;
      if (data != null) {
        try {
          var jsonData = json.decode(data);
          var newMessage = MessageModel.fromJson(jsonData);

          // Show notification if user is not active in chat
          if (!_isUserActiveInChat()) {
            _showLocalNotification(newMessage.message);
          }
        } catch (e) {
          print("Error processing notification: $e");
        }
      }
    });
  }

  bool _isUserActiveInChat() {
    return Get.currentRoute == Routes.MESSAGING;
  }

  void _showLocalNotification(MessageDataModel? message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'high_importance_channel_message',
      'High Importance Notifications Message',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.min,
      priority: Priority.min,
      showWhen: false,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'New message from Customer',
      message?.message,
      platformChannelSpecifics,
      payload: jsonEncode(message),
    );

  }

  void initLocalNotification() {
    // Android-specific initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS-specific initialization settings
    DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
     // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // Combine Android and iOS initialization settings
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
     // onDidReceiveNotificationResponse: onSelectNotification,
      /*onDidReceiveNotificationResponse: (NotificationResponse response) async {
        
        if (response.payload != null) {
          onSelectNotification(response);
        }
      },*/
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        await _handleNotificationTap(response);
      },
    );
  }

  // Handle notifications on iOS versions < 10
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle older iOS notifications
    Get.dialog(
      AlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _handleDisconnection() {
    Future.delayed(const Duration(seconds: 5), () {
      pusher.connect();
    });
  }

  void _playNotificationSound() {
    audioPlayer.play(AssetSource('notification_sound.wav'), volume: .1);
  }

  @override
  void onClose() {
    pusher.disconnect();
    super.onClose();
  }

  Future<void> onSelectNotification(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null && payload.contains("message")) {
      // Parse the payload and navigate to the messaging screen
      Get.put(MessagingController());
      Get.find<MessagingController>().loadPreviousMessage();
      Get.toNamed(Routes.MESSAGING);
    }
  }

  Future<void> _handleNotificationTap(NotificationResponse response) async {
    String? payload = response.payload;
    if (payload != null) {
      final messageData = jsonDecode(payload) as Map<String, dynamic>;

      // Ensure MessagingController is initialized
      Get.put(MessagingController());
      Get.find<MessagingController>().loadPreviousMessage();

      // Navigate to the Messaging screen
      Get.toNamed(Routes.MESSAGING);
    }
  }
}
