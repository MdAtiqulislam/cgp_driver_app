import 'package:get/get.dart';

import '../controllers/verify_o_t_p_controller.dart';

class VerifyOTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyOTPController>(
      () => VerifyOTPController(),
    );
  }
}
