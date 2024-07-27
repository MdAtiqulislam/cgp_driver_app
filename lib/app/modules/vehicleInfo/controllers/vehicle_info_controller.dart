import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VehicleInfoController extends GetxController {


  var vehicleTypeList=["Vehicle type 1","Vehicle type 2","Vehicle type 3"];

  var licenseAuthorizedOfficeList=["Office 1","Office 2","Office 3"];

  var capacityController=TextEditingController();
  var vehicleRegistrationController=TextEditingController();
  var vehicleTaxTokenController=TextEditingController();
  var ownerNameController=TextEditingController();
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
}
