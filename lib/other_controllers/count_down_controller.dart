import 'package:get/get.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class CountdownController extends GetxController {
  RxDouble progressValue = 1.0.obs;
  RxInt remainingTime = 15.obs;
  late AudioPlayer audioPlayer;

  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    startCountdown();
  }

  void startCountdown() {
    playSound();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value <= 0) {
        timer.cancel();
      } else {
        remainingTime.value -= 1;
        progressValue.value = remainingTime.value / 15.0;
      }
    });
  }

  void playSound() async {
    try {
      // Play sound
      await audioPlayer.setSourceAsset('sound.mp3');
      audioPlayer.resume();
      await Vibration.vibrate(duration: 500); // Vibrate for 500 milliseconds
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
