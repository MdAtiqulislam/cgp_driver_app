import 'package:get/get.dart';

import '../controllers/driver_info_controller.dart';

class DriverInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverInfoController>(
      () => DriverInfoController(),
    );
  }
}
