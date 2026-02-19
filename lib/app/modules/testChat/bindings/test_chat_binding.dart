import 'package:get/get.dart';

import '../controllers/test_chat_controller.dart';

class TestChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestChatController>(
      () => TestChatController(),
    );
  }
}
