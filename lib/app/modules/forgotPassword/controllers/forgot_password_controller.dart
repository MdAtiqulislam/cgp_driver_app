import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../services/api_endpoints.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../registration/models/otp_moddel.dart';
import '../../verifyOTP/controllers/verify_o_t_p_controller.dart';

class ForgotPasswordController extends GetxController {

  var otpModel=OtpModel();
  var isLoading=false.obs;

  var emailController=TextEditingController();



  @override
  void onClose() {}

  Future<void> getOtp() async {
    isLoading.value=true;
    const endPoint = APIEndPoints.forgotPassword;
    final body = {
      "identity": emailController.text,
    };

    try {
      final response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        otpModel = OtpModel.fromJson(response);
        CustomSnackBar(
          isSuccess: true,
          msg: otpModel.message ?? "",
        ).showSnackBar();
        isLoading.value = false;
        Get.put(VerifyOTPController());
        Get.find<VerifyOTPController>().email.value=emailController.text;
        Get.find<VerifyOTPController>().isResetPassword=true;
        Get.find<VerifyOTPController>().isLogin=false;
        Get.find<VerifyOTPController>().isRegistration=false;
        Get.find<VerifyOTPController>().sessionId=otpModel.data?.sessionId??"";
        Get.toNamed(Routes.VERIFY_O_T_P);
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: AppStrings.httpErrorMSG.value,
        ).showSnackBar();
        isLoading.value = false;
      }
    } catch (e) {
      CustomSnackBar(
        isSuccess: false,
        msg: '$e',
      ).showSnackBar();
      isLoading.value = false;
    }
  }
}
