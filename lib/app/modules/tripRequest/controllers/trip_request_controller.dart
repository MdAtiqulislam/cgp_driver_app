import 'package:cgp_driver_app/app/modules/generalMap/general_map_controller.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/other_controllers/appbar_controller.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/header_text.dart';

class TripRequestController extends GetxController {
  var isLoading = false.obs;
  var isExpand = false.obs;
  var isClientMode = false.obs;
  var tripRequestDetails = TripRequestDetailsModel().obs;



  @override
  void onClose() {}

  Future<void> getTripDetails(
      {required String requestId, required String notificationId}) async {
    isLoading.value = true;
    var endPoint =
        APIEndPoints.getDeliveryRequestByID.replaceAll("{id}", requestId
            //"666d59b06d0b5b85af39973c"
            );
    try {
      var data = await RemoteServices.getRequest(endPoint: endPoint);
      if (data != null) {
        tripRequestDetails.value = TripRequestDetailsModel.fromJson(data);
        var origin = LatLng(
          tripRequestDetails.value.data?.pickupLocation?.latitude ?? 0.0,
          tripRequestDetails.value.data?.pickupLocation?.longitude ?? 0.0,
        );
        var destination = LatLng(
          tripRequestDetails.value.data?.dropOffLocation?.latitude ?? 0.0,
          tripRequestDetails.value.data?.dropOffLocation?.longitude ?? 0.0,
        );

        Get.put(AppbarController());
        Get.find<AppbarController>().getNotifications();

        Get.put(GeneralMapController());
        Get.find<GeneralMapController>()
            .generateRoute(origin: origin, destination: destination);
        await markAsRead(notificationId: notificationId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onTripAccepted() {
    showDialog(
        context: Get.context!,
        builder: (buildContext) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w, //AppDimensions.horizontalPadding,
                vertical: 24.h, //AppDimensions.verticalPadding
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  const CustomCircleAvatar(width: 50, height: 50, image: AppImagePath.warningIcon),
                     HeaderText(
                      text: "Are you sure to accept the trip from ${tripRequestDetails.value.data?.requestFrom?.name??""}",
                      maxLine: 10,
                      align: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          text: "Yes",
                          onTap: () async {
                            Get.back();
                            startTrip();
                            /*await getRiderVehicle().then((value) {
                              Get.bottomSheet(
                                isScrollControlled: true,
                                ignoreSafeArea: false,
                                // SelectVehicle(),
                              );
                            });*/
                            // startTrip();
                          },
                          bgColor: AppColors.primaryColor,
                          borderRadius: 10.r,
                          horizontalPadding:
                              AppDimensions.horizontalPadding * 2.w,
                        ),
                        SizedBox(width: 16.w //AppDimensions.widgetPaddingHor,
                            ),
                        AppButton(
                          text: "No",
                          onTap: () {
                            Get.back();
                          },
                          bgColor: AppColors.errorColor,
                          borderRadius: 10.r,
                          horizontalPadding:
                              AppDimensions.horizontalPadding * 2.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.sectionPadding.h,
                    ),
                    const BodyText(
                      text:
                          "Once you confirm a trip & then cancel the trip it will affect your profile",
                      align: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> markAsRead({required String notificationId}) async {
    var endPoint = APIEndPoints.markAsReadNotification
        .replaceAll("{notificationId}", notificationId);
    try {
      var data = await RemoteServices.putRequest(endPoint: endPoint);
      if (data != null) {
      }
    } finally {}
  }

  Future<void> startTrip() async {
    isLoading.value = true;


    Get.back();
    try {
      Get.toNamed(Routes.ONGOING_TRIP);

      var endPoint = APIEndPoints.acceptRequest
          .replaceAll(
            "{id}",
            tripRequestDetails.value.data?.id ?? "",
          )
          .replaceAll("{vehicleId}", "");
      var data = await RemoteServices.patchRequest(endPoint: endPoint);
      if (data != null) {
       // Get.back();
        tripRequestDetails.value=TripRequestDetailsModel.fromJson(data);
        await LocalServices.storeOnGoingTrip(
            tripRequestDetails.value.data?.id);
        Get.find<SocketService>().updateOrderId("${tripRequestDetails.value.data?.orderId}");
        Get.put(OngoingTripController());
        Get.find<OngoingTripController>().tripRequestDetails.value=tripRequestDetails.value;
        Get.find<OngoingTripController>().handleStatus();
        Get.find<OngoingTripController>().initMessaging();

      }
      else{
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onTripDeclined() {
    print("ondeclined clicked");
    Get.offAndToNamed(Routes.HOME);
  }


}
