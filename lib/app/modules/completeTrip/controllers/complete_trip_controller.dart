import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:get/get.dart';

class CompleteTripController extends GetxController {
  var isLoading=false.obs;
  var tripRequestDetails=TripRequestDetailsModel().obs;

  var isReviewed=false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
