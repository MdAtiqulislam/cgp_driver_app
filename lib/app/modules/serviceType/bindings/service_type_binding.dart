import 'package:get/get.dart';

import '../controllers/service_type_controller.dart';

class ServiceTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceTypeController>(
      () => ServiceTypeController(),
    );
  }
}
