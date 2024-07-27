import 'package:cgp_driver_app/app/modules/myWallet/models/payment_history_model.dart';
import 'package:cgp_driver_app/app/modules/myWallet/models/todays_earning_data.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:get/get.dart';

class MyWalletController extends GetxController {

  var isLoading=false.obs;
  var todaysEarning=TodaysEarningHistoryModel().obs;
  var paymentHistory=PaymentHistoryModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
   await getPaymentHistoryData();
   await getTodaysEarning();
  }

  @override
  void onReady() {
    super.onReady();
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

}
