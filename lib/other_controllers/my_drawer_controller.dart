import 'package:cgp_driver_app/common_widgets/custom_snackbar.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/notification_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../app/modules/splashScreen/controllers/splash_screen_controller.dart';
import '../app/routes/app_pages.dart';
import '../common_widgets/app_button.dart';
import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/body_text.dart';
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

 //   var notificationServices=Get.put(NotificationServices());

    isLoading.value=true;
    var endPoint = APIEndPoints.logOut;

    try {
      var fcmToken =await FirebaseMessaging.instance.getToken();
      //await notificationServices.getDeviceToken();
      var body = {"device_token": fcmToken};
      var response =
      await RemoteServices.postRequestWithJsonData(
          endPoint: endPoint, body: body);
      if(response!=null){
        CustomSnackBar(
            msg: "You have successfully logged out. See you next time!",
            isSuccess: true
        ).showSnackBar();
      }
    } finally {
      Get.put(SplashScreenController()).token.value="";
      await LocalServices.deleteData();
      Get.find<SocketService>().disconnect();
      isLoading.value=false;
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  void deleteAccount() {
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
                    const HeaderText(text: "Are you sure you want to Remove your account?",maxLine: 3,),
                    Divider(),
                    SizedBox(height: 16.h,),
                    const BodyText(text: "If you remove the account, all of your information will be lost permanently.",maxLine: 10,),
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
                            completeRemoveAccount();
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

  void completeRemoveAccount()async {
    isLoading.value=true;
    var endPoint = APIEndPoints.removeAccount;
    try {
      var response=await RemoteServices.deleteRequest(endPoint: endPoint);
      if(response!=null){
        CustomSnackBar(
          msg: response["message"],
          isSuccess: true
        ).showSnackBar();
      }else{
        CustomSnackBar(
            msg: AppStrings.httpErrorMSG.value,
            isSuccess: false
        ).showSnackBar();
      }
    } finally {
     isLoading.value=false;
     LocalServices.deleteData();
     Get.offAllNamed(Routes.LOGIN);
    }


  }
}
