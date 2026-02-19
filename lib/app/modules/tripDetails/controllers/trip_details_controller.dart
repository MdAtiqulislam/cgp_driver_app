import 'package:cgp_driver_app/app/modules/tripDetails/models/trip_history_details_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:get/get.dart';

class TripDetailsController extends GetxController {

  var isLoading=false.obs;
  var tripDetails=TripHistoryDetailsModel().obs;



  @override
  void onClose() {}
Future<void>getTripDetails({required String id})async{
    isLoading.value=true;
    var endPoint=APIEndPoints.tripDetails.replaceAll("{id}", id);
    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint);
      if(response!=null){
        tripDetails.value=TripHistoryDetailsModel.fromJson(response);
      }
    } finally {
      isLoading.value=false;
    }
}
}
