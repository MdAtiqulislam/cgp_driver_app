/*
import 'dart:io';
import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:cgp_driver_app/utils/enams.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../../services/local_services.dart';
import '../../../../services/pusher_services.dart';
import '../../../routes/app_pages.dart';
import '../models/appversion_model.dart';

class SplashScreenController extends GetxController {
 // NotificationServices notificationServices = NotificationServices();
  var isLoading = false.obs;
  var appVersionModel = AppVersionModel().obs;
  var onGoingTripDetails = TripRequestDetailsModel().obs;
  var token="".obs;

  @override
  void onInit() async{
    token.value=await LocalServices.getToken()??"";
   // notificationServices.setupInterruptMessage(Get.context!);
    super.onInit();
    // getLoginStatus();
    getAppVersion();
  }

  @override
  void onClose() {}

  Future<void> getLoginStatus() async {
    isLoading.value=true;
    try {
      final token = await LocalServices.getToken();
      if (token != null) {
        Get.find<SocketService>().startLocationUpdates();
        await LocalServices.getUser().then((value) {
          Get.put(PusherService((value?.userId ?? "").toString()));
        });
        final onGoingTripId = await LocalServices.getOnGoingTrip();

        if (onGoingTripId == null || onGoingTripId == "null"|| onGoingTripId.isEmpty) {
          Get.offAllNamed(Routes.HOME);
        } else {
          openOngoingTrip(id: onGoingTripId);
        }
      }
    } finally {
      isLoading.value=false;
    }
  }

  void openOngoingTrip({required String id}) async {
    //isLoading.value = true;

    var endPoint = APIEndPoints.getDeliveryRequestByID.replaceAll("{id}", id);
    try {
      var response = await RemoteServices.getRequest(endPoint: endPoint);
      if (response != null) {
        onGoingTripDetails.value = TripRequestDetailsModel.fromJson(response);

        if(
        (onGoingTripDetails.value.data?.status??"")==OrderStatus.cancelled.name||
        (onGoingTripDetails.value.data?.status??"")==OrderStatus.expired.name||
        (onGoingTripDetails.value.data?.status??"")==OrderStatus.delivered.name||
        (onGoingTripDetails.value.data?.status??"")=="cancelled"
        ){

          Get.offAllNamed(Routes.HOME);
        }else{
          Get.put(OngoingTripController());
          Get.find<SocketService>()
              .updateOrderId("${onGoingTripDetails.value.data?.orderId}");
          Get.find<OngoingTripController>().tripRequestDetails.value =
              onGoingTripDetails.value;
          Get.find<OngoingTripController>().handleStatus();
          Get.find<OngoingTripController>().initMessaging();
          Get.toNamed(Routes.ONGOING_TRIP);
        }
      }
    } finally {
     // isLoading.value = false;
    }
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var currentAppVersion = packageInfo.version;
    var endPoint = APIEndPoints.appVersionEndpoint;
    try {
      var response =
          await RemoteServices.getRequestForResponseBody(endPoint: endPoint);
      if (response != null) {
        appVersionModel.value = AppVersionModel.fromJson(response);
        checkAppVersion(currentAppVersion);
      }
    } finally {}
  }

  void checkAppVersion(String currentAppVersion) {
    if (Platform.isIOS) {
      if (currentAppVersion == (appVersionModel.value.iosVersion ?? "1.0.8") ||
          currentAppVersion ==
              (appVersionModel.value.iosTestVersion ?? "1.0.8") ||
          appVersionModel.value.iosTestVersion == "1.0.7") {
        handleLocationFlow(); // 🔥 changed
      } else {
        showForceUpdateDialog();
      }
    } else if (Platform.isAndroid) {
      if (currentAppVersion == appVersionModel.value.androidVersion ||
          currentAppVersion ==
              (appVersionModel.value.androidTestVersion ?? "1.0.2")) {
        getLoginStatus();
        //handleLocationFlow(); // 🔥 changed
      } else {
        showForceUpdateDialog();
      }
    }
  }

  Future<void> handleLocationFlow() async {
    var status = await Permission.locationAlways.status;

    if (status.isGranted && appVersionModel.value.androidTestVersion!="1.0.9") {
      getLoginStatus();
    } else {
      showLocationDisclosure();
    }
  }

  void showLocationDisclosure() {
    Get.dialog(
      AlertDialog(
        title: const Text("Background Location Required"),
        content: const SingleChildScrollView(
          child: Text(
              "This app collects location data to enable live driver tracking "
                  "even when the app is closed or not in use.\n\n"
                  "Location data is used to:\n"
                  "• Track trips in real-time\n"
                  "• Ensure customer safety\n"
                  "• Improve delivery monitoring\n\n"
                  "Location data is securely transmitted to our server and is not shared with third parties.\n\n"
                  "By tapping 'Allow', you consent to background location access."
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text("Deny"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await requestLocationPermission();
            },
            child: const Text("Allow"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> requestLocationPermission() async {
    var whenInUse = await Permission.locationWhenInUse.request();

    if (whenInUse.isGranted) {
      var always = await Permission.locationAlways.request();

      if (always.isGranted) {
        getLoginStatus();
      } else {
        SystemNavigator.pop();
      }
    } else {
      SystemNavigator.pop();
    }
  }




  void showForceUpdateDialog() {
    //_deleteCacheDir();
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            titlePadding: const EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.borderRadius.r),
                  topRight: Radius.circular(AppDimensions.borderRadius.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0.h,horizontal: AppDimensions.horizontalPadding.w),
                child: HeaderText(
                  text: appVersionModel.value.majorMsg?.title ?? "",
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            content: BodyText(
              text: appVersionModel.value.majorMsg?.msg ?? "",
              maxLine: 10,
              size: 14,
            ),
            actions: <Widget>[
              MaterialButton(
                autofocus: true,
                textColor: Colors.white,
                focusColor: AppColors.primaryColor,
                splashColor: AppColors.primaryColor,
                color: AppColors.primaryColor,
                focusElevation: 5,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                // color: AppColors.mainColorRed,
                onPressed: () {
                  if (Platform.isAndroid) {
                    final appId = appVersionModel.value.majorMsg!.url!.apk!
                        .split("id")[1];
                    final url = Uri.parse("market://details?id$appId");
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } else if (Platform.isIOS) {
                    final url = Uri.parse(
                        appVersionModel.value.majorMsg!.url!.ios.toString());
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: const Text(
                  "Update",
                ),
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textColor: AppColors.primaryColor,
                  splashColor: AppColors.primaryColor,
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text("Cancel"))
            ],
          ),
        );
      },
    );
  }
}

*/

import 'dart:io';
import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:cgp_driver_app/utils/enams.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';
import '../../../../services/local_services.dart';
import '../../../../services/pusher_services.dart';
import '../../../routes/app_pages.dart';
import '../models/appversion_model.dart';

class SplashScreenController extends GetxController {
  var isLoading = false.obs;
  var appVersionModel = AppVersionModel().obs;
  var onGoingTripDetails = TripRequestDetailsModel().obs;
  var token = "".obs;

  @override
  void onInit() {
    super.onInit();

    /// 🔥 NEVER async directly here
    _init();
  }

  /// ✅ SAFE INIT
  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 300)); // 🔥 stabilize plugins

    try {
      token.value = await LocalServices.getToken() ?? "";
    } catch (e) {
      debugPrint("Token error: $e");
    }

    await getAppVersion();
  }

  /// ===========================
  /// LOGIN FLOW
  /// ===========================
  Future<void> getLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 200)); // 🔥 safety

    isLoading.value = true;

    try {
      final token = await LocalServices.getToken();

      if (token != null) {
        /// 🔥 Start socket AFTER everything ready
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.find<SocketService>().startLocationUpdates();
        });

        final user = await LocalServices.getUser();
        Get.put(PusherService((user?.userId ?? "").toString()));

        final onGoingTripId = await LocalServices.getOnGoingTrip();

        if (onGoingTripId == null ||
            onGoingTripId == "null" ||
            onGoingTripId.isEmpty) {
          Get.offAllNamed(Routes.HOME);
        } else {
          openOngoingTrip(id: onGoingTripId);
        }
      }
    } catch (e) {
      debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ===========================
  /// ONGOING TRIP
  /// ===========================
  void openOngoingTrip({required String id}) async {
    var endPoint =
    APIEndPoints.getDeliveryRequestByID.replaceAll("{id}", id);

    try {
      var response = await RemoteServices.getRequest(endPoint: endPoint);

      if (response != null) {
        onGoingTripDetails.value =
            TripRequestDetailsModel.fromJson(response);

        String status = onGoingTripDetails.value.data?.status ?? "";

        if (status == OrderStatus.cancelled.name ||
            status == OrderStatus.expired.name ||
            status == OrderStatus.delivered.name ||
            status == "cancelled") {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.put(OngoingTripController());

          Get.find<SocketService>().updateOrderId(
              "${onGoingTripDetails.value.data?.orderId}");

          Get.find<OngoingTripController>().tripRequestDetails.value =
              onGoingTripDetails.value;

          Get.find<OngoingTripController>().handleStatus();
          Get.find<OngoingTripController>().initMessaging();

          Get.toNamed(Routes.ONGOING_TRIP);
        }
      }
    } catch (e) {
      debugPrint("Trip error: $e");
    }
  }

  /// ===========================
  /// VERSION CHECK
  /// ===========================
  Future<void> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var currentAppVersion = packageInfo.version;

      var response = await RemoteServices.getRequestForResponseBody(
          endPoint: APIEndPoints.appVersionEndpoint);

      if (response != null) {
        appVersionModel.value = AppVersionModel.fromJson(response);
        checkAppVersion(currentAppVersion);
      }
    } catch (e) {
      debugPrint("Version error: $e");
    }
  }

  void checkAppVersion(String currentAppVersion) {
    if (Platform.isAndroid) {
      if (currentAppVersion == appVersionModel.value.androidVersion ||
          currentAppVersion ==
              (appVersionModel.value.androidTestVersion ?? "")) {
        getLoginStatus();
      } else {
        showForceUpdateDialog();
      }
    } else {
      getLoginStatus(); // iOS fallback
    }
  }

  /// ===========================
  /// LOCATION PERMISSION
  /// ===========================
  Future<void> handleLocationFlow() async {
    var status = await Permission.locationAlways.status;

    if (status.isGranted) {
      getLoginStatus();
    } else {
      showLocationDisclosure();
    }
  }

  void showLocationDisclosure() {
    Get.dialog(
      AlertDialog(
        title: const Text("Background Location Required"),
        content: const Text(
            "This app collects location data to enable live tracking."),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Deny"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await requestLocationPermission();
            },
            child: const Text("Allow"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> requestLocationPermission() async {
    var whenInUse = await Permission.locationWhenInUse.request();

    if (whenInUse.isGranted) {
      var always = await Permission.locationAlways.request();

      if (always.isGranted) {
        getLoginStatus();
      } else {
        SystemNavigator.pop();
      }
    } else {
      SystemNavigator.pop();
    }
  }

  /// ===========================
  /// FORCE UPDATE
  /// ===========================
  void showForceUpdateDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: HeaderText(
            text: appVersionModel.value.majorMsg?.title ?? "",
            size: 18,
            color: AppColors.primaryColor,
          ),
          content: BodyText(
            text: appVersionModel.value.majorMsg?.msg ?? "",
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(
                    appVersionModel.value.majorMsg?.url?.apk ?? "");
                await launchUrl(url,
                    mode: LaunchMode.externalApplication);
              },
              child: const Text("Update"),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
