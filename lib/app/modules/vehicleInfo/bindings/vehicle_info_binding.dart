import 'package:get/get.dart';

import '../controllers/vehicle_info_controller.dart';

class VehicleInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleInfoController>(
      () => VehicleInfoController(),
    );
  }
}
