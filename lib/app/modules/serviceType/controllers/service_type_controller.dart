import 'package:cgp_driver_app/app/modules/registration/controllers/registration_controller.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ServiceTypeController extends GetxController {


  var selectedServiceType="";
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


  void openRegistration() {
    Get.put(RegistrationController());
    Get.find<RegistrationController>().serviceType.value=selectedServiceType;
    Get.toNamed(Routes.REGISTRATION);
  }
}
