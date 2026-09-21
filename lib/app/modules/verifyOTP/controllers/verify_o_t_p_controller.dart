import 'dart:async';

import 'package:cgp_driver_app/app/modules/home/controllers/home_controller.dart';
import 'package:cgp_driver_app/models/login_verification_model.dart';
import 'package:cgp_driver_app/other_controllers/appbar_controller.dart';
import 'package:cgp_driver_app/other_controllers/my_drawer_controller.dart';
import 'package:cgp_driver_app/services/location_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../models/rider_model.dart';
import '../../../../services/api_endpoints.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../password/controllers/password_controller.dart';
import '../models/verify_otp_model.dart';

class VerifyOTPController extends GetxController {


  final FocusNode focusNode = FocusNode();
  var email="".obs;
  var isLoading = false.obs;
  var isValidate = false.obs;
  var wrongOTP = false.obs;
  var resendOtpTime = 60.obs;
  var otp = "";
  var verifyOTPModel = VerifyOtpModel();
  var loginModel = LoginVerificationModel();

  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  final c6 = TextEditingController();

  Timer? timer;

  var isRegistration = false;
  var isLogin = false;
  var isResetPassword = false;
  var deviceToken="".obs;
  String sessionId = "";
  @override
  void onInit() async{
    super.onInit();
    startTimer();

       //await NotificationServices().getDeviceToken().then((value){
    await FirebaseMessaging.instance.getToken().then((value){
      deviceToken.value=value??"";
      print("Device token: $value");
    });
  }


  @override
  void onClose() {}



  void checkOtpLength(String? value) {
    if ((value ?? "").length >= 6) {
      c1.text = value![0];
      c2.text = value[1];
      c3.text = value[2];
      c4.text = value[3];
      c5.text = value[4];
      c6.text = value[5];
      verifyOTP();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpTime.value > 0) {
        resendOtpTime.value--;
      }
      if (resendOtpTime.value <= 0) {
        resendOtpTime.value = 0;
        timer.cancel();
      }
      if (isValidate.value) {
        timer.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    resendOtpTime.value = 180;

    startTimer();
    isLoading.value = true;
    const endPoint = APIEndPoints.reSendOTP;
    final body = {
      "session_id": sessionId,
    };

    try {
      final response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {

        c1.text ="";
        c2.text ="";
        c3.text ="";
        c4.text = "";
        c5.text = "";
        c6.text = "";
        focusNode.requestFocus();

        isLoading.value = false;
        resendOtpTime.value = 180;
        startTimer();
        CustomSnackBar(
          isSuccess: true,
          msg: response["message"],
        ).showSnackBar();
      } else {
        isLoading.value = false;
        CustomSnackBar(
          isSuccess: false,
          msg: AppStrings.httpErrorMSG.value,
        ).showSnackBar();
      }
    } catch (e) {
      isLoading.value = false;
      CustomSnackBar(
        isSuccess: false,
        msg: '$e',
      ).showSnackBar();
    }
  }


  Future<void> verifyOTP() async {
    isLoading.value = true;
    final endPoint = isLogin ? APIEndPoints.loginVerification : APIEndPoints.emailVerification;
    otp = c1.text + c2.text + c3.text + c4.text + c5.text + c6.text;
    final body = {
      "session_id": sessionId,
      "otp": otp,
      "device_token": deviceToken.value,
    };

    try {
      final response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response !=null) {
        isValidate.value = true;
        isLoading.value = false;
        if (isLogin) {
          updateRiderLocation();
          loginModel = LoginVerificationModel.fromJson(response);
          await LocalServices.storeToken(loginModel.data?.accessToken ?? "");
         // print("Request Id:${loginModel.data?.rider?.ongoingTrip?.deliveryRequestId}");
          await LocalServices.storeOnGoingTrip((loginModel.data?.rider?.ongoingTrip?.deliveryRequestId).toString());

         var riderJson= loginModel.data?.rider?.toJson();
         riderJson?["is_active"]=false;

        // await LocalServices().storeUser(loginModel.data?.rider??RiderModel());
        // await LocalServices().storeUser(RiderModel.fromJson(riderJson!));
         await LocalServices.storeUser(RiderModel.fromJson(riderJson!));
        } else {
          verifyOTPModel = VerifyOtpModel.fromJson(response);
        }
      } else {
        CustomSnackBar(isSuccess: false,
            msg: AppStrings.httpErrorMSG.value
             ).showSnackBar();
        isLoading.value = false;
        isValidate.value = false;
      }
    } catch (e) {
      CustomSnackBar(isSuccess: false, msg: '$e').showSnackBar(); // Handle error
      isLoading.value = false;
      isValidate.value = false;
    }
  }


  Future<void> handelNext() async {
    if (isLogin) {
      Get.put(AppbarController());
      Get.find<AppbarController>().getUserData();
      Get.put(MyDrawerController());
      Get.find<MyDrawerController>().getUserData();
      Get.find<HomeController>().getOnGoingTrip();
    // await Get.put(StatusSectionController()).changeOnlineStatus(status: false);
      Get.find<HomeController>().getRiderData();
      Get.offAllNamed(Routes.HOME);
    }else if(isResetPassword){
      Get.put(PasswordController());
      Get.find<PasswordController>().isRegistration.value = isRegistration;
      Get.find<PasswordController>().isResetPassword = isResetPassword;
      Get.find<PasswordController>().otp = otp;
      Get.find<PasswordController>().sessionId.value =
          verifyOTPModel.data?.sessionId ?? "";
      Get.toNamed(Routes.PASSWORD);
    }
    else{
      Get.put(PasswordController());
      Get.find<PasswordController>().isRegistration.value = isRegistration;
      Get.find<PasswordController>().sessionId.value =
          verifyOTPModel.data?.sessionId ?? "";
      Get.toNamed(Routes.PASSWORD);
    }

  }

  void updateRiderLocation() async{
 var position=await   LocationServices.getCurrentLocation();
 var endPoint=APIEndPoints.updateRiderLocation;
 var body={
   "latitude": position?.latitude.toString(),
   "longitude": position?.longitude.toString()
 };

 var response=await RemoteServices.putRequest(endPoint:endPoint ,body: body);
 if(response!=null){
   Get.find<SocketService>().startLocationUpdates();
 }
  }
}
