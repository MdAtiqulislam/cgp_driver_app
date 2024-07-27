import 'dart:async';

import 'package:cgp_driver_app/app/modules/generalMap/general_map_controller.dart';
import 'package:cgp_driver_app/app/modules/home/models/rider_profile_model.dart';
import 'package:cgp_driver_app/app/modules/statusSection/status_section_controller.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../../services/notification_services.dart';
import '../../../../services/pusher_services.dart';
import '../../../routes/app_pages.dart';
import '../../tripRequest/controllers/trip_request_controller.dart';



class HomeController extends GetxController {
 var isLoading=false.obs;
 var rider=RiderModel().obs;
 //NotificationServices notificationServices = NotificationServices();
 var mapController=Get.put(MapController());

 @override
  void onInit() async{
  // notificationServices.setupInterruptMessage(Get.context!);
    await getRiderData();
    super.onInit();
   WidgetsBinding.instance.addPostFrameCallback((_) {
     handleForegroundNotification(Get.context!);
   });

    Get.put(PusherService((rider.value.userId??"").toString()));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

 Future<void> getRiderData()async {
    isLoading.value=true;
    try {
      rider.value=await LocalServices.getUser()??RiderModel();
      print("rider.value.isApproved:${rider.value.isApproved}");

      if((rider.value.isApproved??false)){
        mapController.isApproved.value=true;
      }else{

        await reloadData();
      }
    } finally {
      isLoading.value=false;
    }
 }

Future<void>  reloadData() async{
    isLoading.value=true;
    var endPoint=APIEndPoints.getUserData;
    var riderProfile=RiderProfileModel();
    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint);
      if(response!=null){
        riderProfile=RiderProfileModel.fromJson(response);
        rider.value=riderProfile.data??RiderModel();
        if(rider.value.isApproved??false){
          mapController.isApproved.value=true;
          Get.put(StatusSectionController());
          Get.find<StatusSectionController>().rider.value=rider.value;
          await LocalServices().storeUser(rider.value);
        }else{
          mapController.isApproved.value=false;
        }
      }
    } finally {
     isLoading.value=false;
    }
}


 void handleForegroundNotification(BuildContext context) async {
   const storage = FlutterSecureStorage();
   String? requestId = await storage.read(key: 'requestId');
   String? notificationId = await storage.read(key: 'notificationId');

   if (requestId != null && notificationId != null) {
     // Assuming you have already registered the TripRequestController
     Get.put(TripRequestController());
     Get.find<TripRequestController>().getTripDetails(requestId: requestId, notificationId: notificationId);
     Get.toNamed(Routes.TRIP_REQUEST);

     // Clear the saved data
     await storage.delete(key: 'requestId');
     await storage.delete(key: 'notificationId');
   }
 }

}
