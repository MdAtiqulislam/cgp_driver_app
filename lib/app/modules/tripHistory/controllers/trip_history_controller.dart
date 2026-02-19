import 'package:cgp_driver_app/app/modules/tripHistory/models/trip_history_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:get/get.dart';

class TripHistoryController extends GetxController {

  var isLoading=false.obs;
  var tripHistory=TripHistoryModel().obs;
  @override
  void onInit() {
    super.onInit();
    getTripHistory();
  }


  @override
  void onClose() {}

  Future<void> getTripHistory() async{
    isLoading.value=true;
    var endPoint=APIEndPoints.getTripHistory;
    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint);
      if(response!=null){
        tripHistory.value=TripHistoryModel.fromJson(response);
      }
    } finally {
      isLoading.value=false;
    }
  }
}
