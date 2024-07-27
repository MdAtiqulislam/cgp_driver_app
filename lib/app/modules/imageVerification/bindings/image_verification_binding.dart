import 'package:get/get.dart';

import '../controllers/image_verification_controller.dart';

class ImageVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageVerificationController>(
      () => ImageVerificationController(),
    );
  }
}
