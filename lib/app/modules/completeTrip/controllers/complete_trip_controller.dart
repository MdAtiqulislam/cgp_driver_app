import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:cgp_driver_app/utils/delivery_proof_image_upload.dart';
import 'package:get/get.dart';

class CompleteTripController extends GetxController {
  var isLoading=false.obs;
  var tripRequestDetails=TripRequestDetailsModel().obs;
  var isReviewed=false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }


  @override
  void onClose() {}
}
