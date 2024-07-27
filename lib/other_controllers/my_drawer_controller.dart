import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/notification_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../app/routes/app_pages.dart';
import '../common_widgets/app_button.dart';
import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';
import '../services/local_services.dart';
import '../services/socket_service.dart';

class MyDrawerController extends GetxController {
  var rider = RiderModel().obs;
  var isLoading=false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserData();
  }

  Future<void> getUserData() async {
    await LocalServices.getUser().then((value) {
      if (value != null) {
        rider.value = value;
      }
    });
  }

  void logOut() {
    showDialog(
        context: Get.context!,
        builder: (buildContext) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.verticalPadding.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppImagePath.warningIcon),
                    SizedBox(height: 16.h //AppDimensions.widgetPaddingVer,
                        ),
                    //  const CustomCircleAvatar(width: 50, height: 50, image: AppImagePath.warningIcon),
                    const HeaderText(text: "Are you sure you want to log out?"),
                    SizedBox(height: 32.h //AppDimensions.sectionPaddingVer,
                        ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          text: "Cancel",
                          showBorder: true,
                          onTap: () {
                            Get.back();
                          },
                          bgColor: AppColors.primaryColor,
                        ),
                        SizedBox(width: 16.w //AppDimensions.widgetPaddingHor,
                            ),
                        AppButton(
                          text: "Confirm",
                          borderColor: AppColors.primaryColor,
                          showBorder: true,
                          onTap: () async {
                            Get.back();
                            completeLogOut();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> completeLogOut()async {
    isLoading.value=true;
    var endPoint = APIEndPoints.logOut;
    var fcmToken =
    await NotificationServices().getDeviceToken();
    var body = {"device_token": fcmToken};
    try {
      var response =
      await RemoteServices.postRequestWithJsonData(
          endPoint: endPoint, body: body);
      if(response!=null){
        Get.offAllNamed(Routes.SPLASH_SCREEN);
        await LocalServices.deleteData();
        Get.find<SocketService>().disconnect();
      }
    } finally {
      isLoading.value=false;
    }
  }
}
