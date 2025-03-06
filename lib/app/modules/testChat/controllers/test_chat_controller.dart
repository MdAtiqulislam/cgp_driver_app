import 'package:get/get.dart';

class TestChatController extends GetxController {
  //TODO: Implement TestChatController

  final count = 0.obs;


  @override
  void onClose() {}
  void increment() => count.value++;
}
