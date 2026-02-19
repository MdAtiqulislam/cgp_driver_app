import 'package:cgp_driver_app/app/modules/editProfile/models/bank_history_model.dart';
import 'package:cgp_driver_app/app/modules/editProfile/models/rider_vehicles_model.dart';
import 'package:cgp_driver_app/app/modules/editProfile/models/vehicle_type_model.dart';
import 'package:cgp_driver_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:cgp_driver_app/common_widgets/custom_snackbar.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/models/bank_info_model.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/models/single_vehicle_model.dart';
import 'package:cgp_driver_app/models/single_vehicle_type_model.dart';
import 'package:cgp_driver_app/other_controllers/appbar_controller.dart';
import 'package:cgp_driver_app/other_controllers/my_drawer_controller.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/utils/enams.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/utils.dart';

class EditProfileController extends GetxController {
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var loadingVehicleInfo = false.obs;
  var loadingBankInfo = false.obs;
  var rider = RiderModel().obs;
  var isExpand = [false, false, false].obs;
  var riderVehicleModel = RiderVehiclesModel().obs;
  var vehicleTypeModel = VehicleTypeModel().obs;
  var bankHistoryModel = BankHistoryModel().obs;
  var base64ImageProfile = "".obs;
  var base64ImageVehicleFront = "".obs;
  var base64ImageVehicleBack = "".obs;


  var dateOfBirthController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var brandController = TextEditingController();
  var modelController = TextEditingController();
  var colorController = TextEditingController();
  var licencePlateController = TextEditingController();
  var registrationNumberController = TextEditingController();
  var drivingLicenseController = TextEditingController();
 // var bankNameController = TextEditingController();
  var bankAccountNumberController = TextEditingController();
  var bankAccountHolderNameController = TextEditingController();
  var bankBSBController = TextEditingController();

  var genders = ["FEMALE", "MALE", "OTHER"];
  var selectedGender = "MALE";
  var selectedVehicleType = SingleVehicleTypeModel();
  var selectedVehicleModel = SingleVehicleModel().obs;
  String profileImage = "";
  String frontImage = "";
  String backImage = "";

  var yearList = <String>[].obs;

  var selectedYear = DateTime.now().year.toString();

  var selectedBank = BankInfoModel().obs;
  var isDefaultBank = false.obs;



  @override
  void onInit() async {
    super.onInit();
    yearList.value = generateBackwardYearList(20);
    await getVehicleTypeList();
    await getUserData();
    await getVehicleInfo();
    await getBankInfoRecord();

  }


  @override
  void onClose() {}

  Future<void> getUserData() async {
    await LocalServices.getUser().then((value) {
      if (value != null) {
        rider.value = value;
        firstNameController.text = rider.value.firstName ?? "";
        lastNameController.text = rider.value.lastName ?? "";
        phoneController.text = rider.value.phone ?? "";
        emailController.text = rider.value.email ?? "";
        drivingLicenseController.text = rider.value.drivingLicenseNumber ?? "";
        selectedGender =
            (rider.value.gender ?? "").isEmpty ? "MALE" : rider.value.gender;
        dateOfBirthController.text = rider.value.dateOfBirth ?? "";
      }
    });
  }

  Future<void> getVehicleInfo() async {
    loadingVehicleInfo.value = true;
    var endPoint = APIEndPoints.getVehicles;
    try {
      var response = await RemoteServices.getRequest(endPoint: endPoint);
      if (response != null) {
        riderVehicleModel.value = RiderVehiclesModel.fromJson(response);
      }
    } finally {
      loadingVehicleInfo.value = false;
    }
  }

  Future<void> selectImage(
      {required ImageSource source, CropStyle? cropStyle,required String imageType})
  async {
    picImage(source).then((value) async {
      if (value != null) {
        Get.back();
        await cropImage(filePath: value.path, cropStyle: cropStyle)
            .then((value) async {
          if (value != null) {
            if(imageType==ImageType.profile.name){
              profileImage = value.path;
              {
                base64ImageProfile.value = await getImageAsBase64(value);
              }
            }else if(imageType==ImageType.vehicleFront.name){
              frontImage = value.path;
              {
                base64ImageVehicleFront.value = await getImageAsBase64(value);
              }
            } if(imageType==ImageType.vehicleBack.name){
              backImage = value.path;
              {
                base64ImageVehicleBack.value = await getImageAsBase64(value);
              }
            }

          }
        });
      }
    });
  }



  void selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      context: Get.context!,
    );
    if (picked != null) {
      dateOfBirthController.text = DateFormat("yyyy-MM-dd").format(picked);
    }
  }

  Future<void> updateUser() async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.updateUser;
    var body = {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "phone": phoneController.text.length==8?"04${phoneController.text}":phoneController.text,
      "email": emailController.text,
      "date_of_birth": dateOfBirthController.text,
      "driving_license_number": drivingLicenseController.text,
      "gender": selectedGender,
    };

    try {
      var response = await RemoteServices.multipartRequest(
          endPoint: endPoint,
          body: body,
          filePath: profileImage,
          fieldName: 'profile_image',
          requestType: "PATCH");
      if (response != null) {
        var riderJason=rider.value.toJson();
        riderJason["first_name"]=firstNameController.text;
        riderJason["last_name"]=lastNameController.text;
        riderJason["phone"]=phoneController.text;
        riderJason["email"]=emailController.text;
        riderJason["date_of_birth"]=dateOfBirthController.text;
        riderJason["driving_license_number"]=drivingLicenseController.text;
        riderJason["gender"]=selectedGender;
        rider.value=RiderModel.fromJson(riderJason);
        //await LocalServices().storeUser(rider.value);
        await LocalServices.storeUser(rider.value);
        reloadData();
        resetFields();
        CustomSnackBar(msg: response["message"], isSuccess: true)
            .showSnackBar();
      } else {
        CustomSnackBar(msg: AppStrings.httpErrorMSG.value, isSuccess: false)
            .showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void reloadData() {
    base64ImageProfile.value = "";
    getUserData();
    Get.put(AppbarController());
    Get.find<AppbarController>().getUserData();
    Get.put(MyDrawerController());
    Get.find<MyDrawerController>().getUserData();
    Get.put(ProfileController());
    Get.find<ProfileController>().getUserData();
  }

  Future<void> getVehicleTypeList() async {

    loadingVehicleInfo.value=true;
    var endPoint = APIEndPoints.getVehicleType;
    var response = await RemoteServices.getRequest(endPoint: endPoint);
    if (response != null) {
      vehicleTypeModel.value = VehicleTypeModel.fromJson(response);
    }
  }


  Future<void> addNewVehicle() async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.addNewVehicle;
    var body = getVehicleFormData();
    try {
      var response = await RemoteServices.multipartRequestAddOrUpdateVehicle(
        filePaths: [frontImage, backImage],
        fieldNames: ["vehicle_front_image", "vehicle_back_image"],
        endPoint: endPoint,
        requestType: "POST",
        body: body,
      );
      if (response != null) {
        Get.back();
        getVehicleInfo();
        reloadData();
        resetFields();

        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      }
      else {
        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }




/*  Future<void> addNewVehicle() async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.addNewVehicle;
    var body = getVehicleFormData();
    try {
      var response = await RemoteServices.multipartRequest(
          filePath: filePath,
          fieldName: "vehicle_image",
          endPoint: endPoint,
          requestType: "POST",
          body: body);
      if (response != null) {
        Get.back();
        getVehicleInfo();
        reloadData();

        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      } else {
        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }*/

  void updateVehicle() async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.updateVehicle
        .replaceAll("{vehicle_id}", selectedVehicleModel.value.id.toString());
    var body = getVehicleFormData();

    try {
      var response = await RemoteServices.multipartRequestAddOrUpdateVehicle(
        filePaths: [frontImage, backImage],
        fieldNames: ["vehicle_front_image", "vehicle_back_image"],
        endPoint: endPoint,
        requestType: "PUT",
        body: body,
      );
      if (response != null) {
        Get.back();
        getVehicleInfo();
        reloadData();
        resetFields();

        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      }
      else {
        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }


 /*   try {
      var response = await RemoteServices.multipartRequest(
          filePath: profileImage,
          fieldName: "vehicle_image",
          endPoint: endPoint,
          requestType: "PUT",
          body: body);
      if (response != null) {
        Get.back();
        getVehicleInfo();
        reloadData();

        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      } else {
        CustomSnackBar(
          msg: response["message"],
          isSuccess: true,
        ).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }*/
  }




  void setVehicleData() {
    selectedVehicleType = vehicleTypeModel.value.data![
        vehicleTypeModel.value.data!.indexWhere(
            (value) => value.id == selectedVehicleModel.value.type!.id)];
    brandController.text = selectedVehicleModel.value.brand ?? "";
    modelController.text = selectedVehicleModel.value.model ?? "";
    licencePlateController.text = selectedVehicleModel.value.licensePlate ?? "";
    registrationNumberController.text =
        selectedVehicleModel.value.registrationNumber ?? "";
    selectedYear =
        (selectedVehicleModel.value.year ?? DateTime.now().year).toString();
  }

  Map<String, String> getVehicleFormData() {
    return {
      "type_id": selectedVehicleType.typeId.toString(),
      "brand": brandController.text,
      "model": modelController.text,
      "license_plate": licencePlateController.text,
      "registration_number": licencePlateController.text,
      "year": selectedYear,
    };
  }

  Future<void> getBankInfoRecord() async {
    loadingBankInfo.value = true;
    var endPoint = APIEndPoints.getBankInfoRecord;
    try {
      var response = await RemoteServices.getRequest(endPoint: endPoint);
      if (response != null) {
        bankHistoryModel.value = BankHistoryModel.fromJson(response);
      }
    } finally {
      loadingBankInfo.value = false;
    }
  }

  Future<void> addNewBankDetails() async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.addNewBank;
    var body = getBankDetailsFormData();
    try {
      var response = await RemoteServices.postRequestWithJsonData(
          endPoint: endPoint, body: body);
      if (response != null) {
        Get.back();
        resetFields();
        CustomSnackBar(msg: response["message"], isSuccess: true)
            .showSnackBar();
        await getBankInfoRecord();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  Map<String, dynamic> getBankDetailsFormData() {
    return {
      "bank_name": "",
      "account_number": bankAccountNumberController.text,
      "account_holder_name": bankAccountHolderNameController.text,
      "bsb": bankBSBController.text,
      "is_default": isDefaultBank.value,
    };
  }

  void setBankData() {
   // bankNameController.text = selectedBank.value.bankName ?? "";
    bankAccountNumberController.text = selectedBank.value.accountNumber ?? "";
    bankAccountHolderNameController.text = selectedBank.value.accountHolderName ?? "";
    bankBSBController.text = selectedBank.value.bsb ?? "";
    isDefaultBank.value = selectedBank.value.isDefault ?? false;
  }

  Future<void> updateBank() async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.updateBankInfo
        .replaceAll("{id}", (selectedBank.value.id ?? 0).toString());

    var body=getBankDetailsFormData();
    try {
      var response=await RemoteServices.patchRequestWithJson(endPoint: endPoint,body: body);
      if(response!=null){
        Get.back();
        resetFields();
        CustomSnackBar(
          msg: response["message"],
          isSuccess: true
        ).showSnackBar();
        await getBankInfoRecord();
      }else{
        CustomSnackBar(
            msg: AppStrings.httpErrorMSG.value,
            isSuccess: false
        ).showSnackBar();
      }
    } finally {
      isUpdating.value=false;
    }
  }

  void resetFields(){
     dateOfBirthController.text="";
     firstNameController.text="";
     lastNameController.text="";
     phoneController.text="";
     emailController.text="";
     brandController.text="";
     modelController.text="";
     colorController.text="";
     licencePlateController.text="";
     registrationNumberController.text="";
     drivingLicenseController.text="";
     bankAccountNumberController.text="";
     bankAccountHolderNameController.text="";
     bankBSBController.text="";
    // base64ImageProfile.value = "";
     base64ImageVehicleFront.value = "";
     base64ImageVehicleBack.value = "";
      frontImage = "";
      backImage = "";
      selectedGender = "MALE";
      selectedVehicleType = SingleVehicleTypeModel();
      selectedVehicleModel.value = SingleVehicleModel();
      selectedYear = DateTime.now().year.toString();

      selectedBank = BankInfoModel().obs;
      isDefaultBank.value = false;
  }
}
