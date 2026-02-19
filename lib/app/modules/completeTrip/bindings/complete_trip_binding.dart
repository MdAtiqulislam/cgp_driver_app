import 'package:get/get.dart';

import '../controllers/complete_trip_controller.dart';

class CompleteTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteTripController>(
      () => CompleteTripController(),
    );
  }
}
