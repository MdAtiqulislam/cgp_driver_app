import 'package:cgp_driver_app/app/modules/registration/models/otp_moddel.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../services/api_endpoints.dart';
import '../../../../services/remote_services.dart';
import '../../verifyOTP/controllers/verify_o_t_p_controller.dart';

class RegistrationController extends GetxController {

  var isLoading=false.obs;

  var serviceType="".obs;

  var otpModel=OtpModel();

  var firstNameController=TextEditingController();
  var lastNameController=TextEditingController();
  var emailController=TextEditingController();
  var phoneController=TextEditingController();

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

  Future<void> registration() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.registration;
    var body = {
      "first_name":firstNameController.text,
      "last_name":lastNameController.text,
      "email": emailController.text,
      "phone": "04${phoneController.text}",
    };
    try {
      var response =
          await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        isLoading.value=false;
        otpModel=OtpModel.fromJson(response);
        Get.put(VerifyOTPController());
        Get.find<VerifyOTPController>().email.value=emailController.text;
        Get.find<VerifyOTPController>().sessionId=otpModel.data?.sessionId??"";
        Get.find<VerifyOTPController>().isRegistration=true;
        Get.toNamed(Routes.VERIFY_O_T_P);
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: AppStrings.httpErrorMSG.value,
        ).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

}
