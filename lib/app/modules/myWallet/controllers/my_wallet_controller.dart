import 'package:cgp_driver_app/app/modules/myWallet/models/payment_history_model.dart';
import 'package:cgp_driver_app/app/modules/myWallet/models/todays_earning_data.dart';
import 'package:cgp_driver_app/common_widgets/custom_snackbar.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/models/bank_info_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../editProfile/models/bank_history_model.dart';

class MyWalletController extends GetxController {

  var isLoading=false.obs;
  var loadingBankInfo=false.obs;

  var todaysEarning=TodaysEarningHistoryModel().obs;
  var paymentHistory=PaymentHistoryModel().obs;
  var bankHistoryModel = BankHistoryModel().obs;


  var bankAccountNumberController = TextEditingController();
  var bankAccountHolderNameController = TextEditingController();
  var bankBSBController = TextEditingController();
  var isDefaultBank = false.obs;

  var selectedBankId="".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
   await getPaymentHistoryData();
   await getTodaysEarning();
  }


  @override
  void onClose() {}

  Future<void>getPaymentHistoryData()async{
    isLoading.value=true;
    var endPoint=APIEndPoints.getPaymentHistory;
    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint);
      if(response!=null){
        paymentHistory.value=PaymentHistoryModel.fromJson(response);
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void>getTodaysEarning()async{
    isLoading.value=true;
    var endPoint=APIEndPoints.earnedToday;
    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint);
      if(response!=null){
        todaysEarning.value=TodaysEarningHistoryModel.fromJson(response);
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void>getBankInfo()async{
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

  Future<void> makePaymentRequest({BankInfoModel? bankDetails})async {
    if(bankDetails?.isDefault??false){
      confirmPaymentRequest();
    }else{
      await changeDefaultBank(id: (bankDetails?.id).toString()).then((value){
        if(value){
          confirmPaymentRequest();
        }
      });
    }
  }


  Future<void> addNewBankDetails() async {
    loadingBankInfo.value = true;
    var endPoint = APIEndPoints.addNewBank;
    var body = getBankDetailsFormData();
    try {
      var response = await RemoteServices.postRequestWithJsonData(
          endPoint: endPoint, body: body);
      if (response != null) {
        Get.back();

      }
    } finally {
      loadingBankInfo.value = false;
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

  Future<void> confirmPaymentRequest() async{
    loadingBankInfo.value=true;
    var endPoint=APIEndPoints.makePaymentRequest;
    try {
      var res=await RemoteServices.postRequest(endPoint: endPoint);
      if(res!=null){
        Get.back();

        CustomSnackBar(
          isSuccess: true,
          msg: res["message"]
        ).showSnackBar();
        await getPaymentHistoryData();
        await getTodaysEarning();
      }else{
        CustomSnackBar(
            isSuccess: false,
            msg: AppStrings.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
      loadingBankInfo.value=false;
    }
  }

 Future<bool> changeDefaultBank({required String id})async {
    loadingBankInfo.value=true;
    var endPoint=APIEndPoints.setDefaultBank.replaceAll("{id}", id);
    try {
      var res=await RemoteServices.putRequest(endPoint: endPoint);
      if(res!=null){
        return true;
      }else{
        CustomSnackBar(
          isSuccess: false,
          msg: AppStrings.httpErrorMSG.value
        ).showSnackBar();
        return false;
      }
    } finally {
      loadingBankInfo.value=false;
    }
 
 }


}
