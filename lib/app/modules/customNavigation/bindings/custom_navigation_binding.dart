import 'package:get/get.dart';

import '../controllers/custom_navigation_controller.dart';

class CustomNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomNavigationController>(
      () => CustomNavigationController(),
    );
  }
}
