import 'package:get/get.dart';

import '../controllers/review_and_ratings_controller.dart';

class ReviewAndRatingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewAndRatingsController>(
      () => ReviewAndRatingsController(),
    );
  }
}
