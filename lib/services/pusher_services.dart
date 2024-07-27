import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import '../app/modules/messaging/controllers/messaging_controller.dart';
import '../models/message_data_model.dart';
import '../models/message_model.dart';

class PusherService extends GetxService {
  late PusherClient pusher;
  late Channel channel;
  final String uid;
  final AudioPlayer audioPlayer = AudioPlayer();

  PusherService(this.uid);

  @override
  void onInit() {
    super.onInit();
    initPusher();
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
    });

    channel = pusher.subscribe('messages.$uid');
    channel.bind('App\\Events\\NewMessageEvent', (event) {
      final data = event?.data;
      if (data != null) {
        try {
          var jsonData = json.decode(data);
          var newMessage = MessageModel.fromJson(jsonData);
          Get.find<MessagingController>().messages.add(newMessage.message ?? MessageDataModel());

          // Play notification sound
          _playNotificationSound();
        } catch (e) {
          // Handle error if needed
        }
      }
    });
  }

  void _handleDisconnection() {
    Future.delayed(const Duration(seconds: 5), () {
      pusher.connect();
    });
  }

  void _playNotificationSound() {
    audioPlayer.play(AssetSource('notification_sound.wav'),volume: .1); // Ensure you have this file in your assets folder
  }

  @override
  void onClose() {
    pusher.disconnect();
    super.onClose();
  }
}
