import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/models/login_verification_model.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/other_controllers/appbar_controller.dart';
import 'package:cgp_driver_app/other_controllers/my_drawer_controller.dart';
import 'package:cgp_driver_app/services/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../services/api_endpoints.dart';
import '../../../../services/local_services.dart';
import '../../../../services/location_services.dart';
import '../../../../services/remote_services.dart';
import '../../../../services/socket_service.dart';
import '../../generalMap/general_map_controller.dart';
import '../../home/controllers/home_controller.dart';

class PasswordController extends GetxController {
  var isRegistration = false.obs;
  var showPassword = false.obs;
  var isLoading = false.obs;
  var deviceToken = "".obs;

  var otp = "";
  var sessionId = "".obs;
  var loginModel=LoginVerificationModel();

  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  bool isResetPassword=false;

  @override
  void onInit() async{
    super.onInit();
    //await NotificationServices().getDeviceToken().then((value){
    await FirebaseMessaging.instance.getToken().then((value){
      deviceToken.value=value??"";
    });
  }


  @override
  void onClose() {}

  Future<void> setPassword() async {

    isLoading.value = true;
    const endPoint = APIEndPoints.setPassword;
    final body = {
      "session_id": sessionId.value,
      "password": newPasswordController.text,
      "password_confirmation": confirmPasswordController.text,
      "device_token":deviceToken.value,
    };

    try {
      final response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        isLoading.value = false;
        loginModel = LoginVerificationModel.fromJson(response);
        await LocalServices.storeToken(loginModel.data?.accessToken ?? "");
        //await LocalServices.storeUser(loginModel.data?.rider??RiderModel());
        await LocalServices.storeUser(loginModel.data?.rider??RiderModel());

        updateRiderLocation();

       Get.put(AppbarController());
       Get.find<AppbarController>().getUserData();
       Get.put(MyDrawerController());
       Get.find<MyDrawerController>().getUserData();
       Get.put(GeneralMapController()).isApproved.value=false;

       Get.offAllNamed(Routes.HOME);



        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      } else {
        CustomSnackBar(
          msg: AppStrings.httpErrorMSG.value,
          isSuccess: false,
        ).showSnackBar();
        isLoading.value = false;
      }
    } catch (e) {
      CustomSnackBar(
        msg: '$e',
        isSuccess: false,
      ).showSnackBar();
      isLoading.value = false;
    }
  }


  Future<void> reSetPassword() async {
    Get.toNamed(Routes.LOGIN);

    isLoading.value = true;
    const endPoint = APIEndPoints.reSetPassword;
    final body = {
      "session_id": sessionId.value,
      "otp":otp,
      "password": newPasswordController.text,
      "password_confirmation": confirmPasswordController.text,
    };

    try {
      final response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        isLoading.value = false;
         loginModel = LoginVerificationModel.fromJson(response);
         await LocalServices.storeToken(loginModel.data?.accessToken ?? "");
        Get.offAllNamed(Routes.LOGIN);
        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      } else {
        CustomSnackBar(
          msg: AppStrings.httpErrorMSG.value,
          isSuccess: false,
        ).showSnackBar();
        isLoading.value = false;
      }
    } catch (e) {
      CustomSnackBar(
        msg: '$e',
        isSuccess: false,
      ).showSnackBar();
      isLoading.value = false;
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
