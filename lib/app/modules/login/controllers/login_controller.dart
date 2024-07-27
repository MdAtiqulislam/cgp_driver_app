import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../services/api_endpoints.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../registration/models/otp_moddel.dart';
import '../../verifyOTP/controllers/verify_o_t_p_controller.dart';

class LoginController extends GetxController {
  var showPassword = false.obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var otpModel=OtpModel();
  var isLoading=false.obs;

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


  void login() async {
    isLoading.value=true;
    var body = {
      "identity": emailController.text,
      "password": passwordController.text
    };
    var endPoint = APIEndPoints.login;

    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) {
      if(value!=null){
        isLoading.value=false;
        otpModel=OtpModel.fromJson(value);
        Get.put(VerifyOTPController());
        Get.find<VerifyOTPController>().email.value=emailController.text;
        Get.find<VerifyOTPController>().sessionId=otpModel.data?.sessionId??"";
        Get.find<VerifyOTPController>().isRegistration=false;
        Get.find<VerifyOTPController>().isResetPassword=false;
        Get.find<VerifyOTPController>().isLogin=true;
        Get.toNamed(Routes.VERIFY_O_T_P);
      }else{
        isLoading.value=false;
        CustomSnackBar(
            msg: AppStrings.httpErrorMSG.value,
            isSuccess: false
        ).showSnackBar();
      }
    });
  }
}
