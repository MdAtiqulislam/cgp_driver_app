import 'package:get/get.dart';

import '../controllers/driving_license_info_controller.dart';

class DrivingLicenseInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrivingLicenseInfoController>(
      () => DrivingLicenseInfoController(),
    );
  }
}
