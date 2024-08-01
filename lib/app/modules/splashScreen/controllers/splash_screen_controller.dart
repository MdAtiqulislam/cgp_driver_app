import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../services/local_services.dart';
import '../../../../services/notification_services.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  NotificationServices notificationServices=NotificationServices();
  var isLoading = false.obs;
  var onGoingTripDetails=TripRequestDetailsModel().obs;

  @override
  void onInit() {
    notificationServices.setupInterruptMessage(Get.context!);
    super.onInit();
    getLoginStatus();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> getLoginStatus() async {
    final token = await LocalServices.getToken();
    isLoading.value =
        false; // Set isLoading to false regardless of token presence
    if (token != null) {
      Get.find<SocketService>().startLocationUpdates();
      final onGoingTripId = await LocalServices.getOnGoingTrip();

      if (kDebugMode) {
        print("Token: $token");
      }
      if (onGoingTripId == null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        openOngoingTrip(id: onGoingTripId);
      }


// Navigate to HOME if token exists
    }
  }

  void openOngoingTrip({required String id})async {
    isLoading.value = true;
    var currentLocation=await getCurrentLocation();
    var endPoint = APIEndPoints.getDeliveryRequestByID.replaceAll("{id}", id);
    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint);
      if(response!=null){
        onGoingTripDetails.value=TripRequestDetailsModel.fromJson(response);
        Get.put(OngoingTripController());
        Get.find<SocketService>().updateOrderId("${onGoingTripDetails.value.data?.orderId}");
        Get.find<OngoingTripController>().tripRequestDetails.value=onGoingTripDetails.value;
        Get.find<OngoingTripController>().handleStatus();
        Get.toNamed(Routes.ONGOING_TRIP);
      }
    } finally {
      isLoading.value=false;
    }
  }
}
