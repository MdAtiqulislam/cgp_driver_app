import 'dart:async';
import 'dart:io';
import 'package:cgp_driver_app/app/modules/generalMap/general_map_controller.dart';
import 'package:cgp_driver_app/app/modules/home/models/rider_profile_model.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:cgp_driver_app/app/modules/statusSection/status_section_controller.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';
import '../../../../services/notification_services.dart';
import '../../../../services/pusher_services.dart';
import '../../../../services/socket_service.dart';
import '../../../routes/app_pages.dart';
import '../../tripRequest/controllers/trip_request_controller.dart';
import '../../tripRequest/models/trip_request_details_model.dart';



class HomeController extends GetxController {
 var isLoading=false.obs;
 var rider=RiderModel().obs;
// NotificationServices notificationServices = NotificationServices();
 var mapController=Get.put(GeneralMapController());
 var onGoingTripDetails=TripRequestDetailsModel().obs;

 @override
  void onInit() async{
  // notificationServices.setupInterruptMessage(Get.context!);
    await getRiderData();
    super.onInit();
   WidgetsBinding.instance.addPostFrameCallback((_) {
     handleForegroundNotification(Get.context!);
   });

    Get.put(PusherService((rider.value.userId??"").toString()));

   await getOnGoingTrip();
  }


  @override
  void onClose() {}

 Future<void> getRiderData()async {


    isLoading.value=true;
    try {
      rider.value=await LocalServices.getUser()??RiderModel();

      var token =await LocalServices.getToken()??"";

    //  print("Is approved: ${rider.value.isApproved}");

      if((rider.value.isApproved??false)){
        mapController.isApproved.value=true;
      }else{
        if(token.isNotEmpty){
          await reloadData();
        }

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
         // await LocalServices().storeUser(rider.value);
          await LocalServices.storeUser(rider.value);
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

  Future<void> getOnGoingTrip()async {

   await LocalServices.getOnGoingTrip().then((value) async {

     if(value!=null && value!="null"){
       isLoading.value = true;
       var endPoint = APIEndPoints.getDeliveryRequestByID.replaceAll("{id}", value);
       try {
         var response=await RemoteServices.getRequest(endPoint: endPoint);
         if(response!=null){
           onGoingTripDetails.value=TripRequestDetailsModel.fromJson(response);
           Get.put(OngoingTripController());
           Get.find<SocketService>().updateOrderId("${onGoingTripDetails.value.data?.orderId}");
           Get.find<OngoingTripController>().tripRequestDetails.value=onGoingTripDetails.value;
           Get.find<OngoingTripController>().handleStatus();
           Get.find<OngoingTripController>().initMessaging();
           Get.toNamed(Routes.ONGOING_TRIP);
         }
       } finally {
         isLoading.value=false;
       }
     }
   });
  }
/*

 void checkAppVersion() async {
   PackageInfo packageInfo = await PackageInfo.fromPlatform();
   var currentAppVersion = packageInfo.version;
   var previousAppVersion = await LocalServices.getPreviousAppVersion() ?? "";
   if (previousAppVersion.toString().isNotEmpty) {
     if (previousAppVersion != currentAppVersion) {
       _deleteCacheDir(currentAppVersion);
     }
   } else {
     LocalServices.storeAppVersion(currentAppVersion);
      }

   const endPoint = AppStrings.getVersionEndPoint;
   var data = await RemoteServices.getRequest(endPoint, {"": ""});
   if (data != null && Platform.isAndroid) {
     appVersionData.value = appVersionModelFromJson(data);
     if (appVersionData.value.version != currentAppVersion &&
         appVersionData.value.androidTestVersion != currentAppVersion) {
       showDialog(
         context: Get.context!,
         barrierDismissible: false,
         builder: (BuildContext context) {
           return WillPopScope(
             onWillPop: () async => false,
             child: AlertDialog(
               actionsAlignment: MainAxisAlignment.center,
               titlePadding: const EdgeInsets.all(0),
               title: Container(
                 color: AppColors.primaryColor,
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 10.0.h),
                   child: HeaderText(
                     text: appVersionData.value.majorMsg?.title ?? "",
                     size: 20,
                     color: Colors.white,
                   ),
                 ),
               ),
               content: BodyText(
                 text: appVersionData.value.majorMsg?.msg ?? "",
                 maxLine: 10,
                 size: 14,
               ),
               actions: <Widget>[
                 MaterialButton(
                   autofocus: true,
                   textColor: AppColors.primaryColor,
                   focusColor: AppColors.primaryColor,
                   splashColor: AppColors.primaryColor,
                   focusElevation: 5,
                   shape: RoundedRectangleBorder(
                     side: const BorderSide(color: AppColors.primaryColor),
                     borderRadius: BorderRadius.circular(12),
                   ),
                   // color: AppColors.mainColorRed,
                   onPressed: () {
                     if (Platform.isAndroid) {
                       final appId = appVersionData.value.majorMsg!.url!.apk!
                           .split("id")[1];
                       final url = Uri.parse("market://details?id$appId");
                       launchUrl(
                         url,
                         mode: LaunchMode.externalApplication,
                       );
                     }
                   },
                   child: const Text(
                     "Update",
                   ),
                 ),
                 MaterialButton(
                     shape: RoundedRectangleBorder(
                       side: const BorderSide(color: AppColors.primaryColor),
                       borderRadius: BorderRadius.circular(12),
                     ),
                     textColor: AppColors.primaryColor,
                     splashColor: AppColors.primaryColor,
                     onPressed: () {
                       SystemNavigator.pop();
                     },
                     child: const Text("Cancel"))
               ],
             ),
           );
         },
       );
     }
   }

   else if (data != null && Platform.isIOS) {
     appVersionData.value = appVersionModelFromJson(data);

     if (appVersionData.value.iosVersion != currentAppVersion &&
         appVersionData.value.iosTestVersion != currentAppVersion) {
       showDialog(
         context: Get.context!,
         barrierDismissible: false,
         builder: (BuildContext context) {
           return WillPopScope(
             onWillPop: () async => false,
             child: AlertDialog(
               actionsAlignment: MainAxisAlignment.center,
               titlePadding: const EdgeInsets.all(0),
               title: Container(
                 color: AppColors.primaryColor,
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 10.0.h),
                   child: HeaderText(
                     text: appVersionData.value.majorMsg?.title ?? "",
                     size: 20,
                     color: Colors.white,
                   ),
                 ),
               ),
               content: BodyText(
                 text: appVersionData.value.majorMsg?.msg ?? "",
                 maxLine: 10,
                 size: 14,
               ),
               actions: <Widget>[
                 MaterialButton(
                   autofocus: true,
                   textColor: AppColors.primaryColor,
                   focusColor: AppColors.primaryColor,
                   splashColor: AppColors.primaryColor,
                   focusElevation: 5,
                   shape: RoundedRectangleBorder(
                     side: const BorderSide(color: AppColors.primaryColor),
                     borderRadius: BorderRadius.circular(12),
                   ),
                   // color: AppColors.mainColorRed,
                   onPressed: () {
                     if (Platform.isIOS) {
                       final url = Uri.parse(
                           appVersionData.value.majorMsg!.url!.ios.toString());
                       launchUrl(
                         url,
                         mode: LaunchMode.externalApplication,
                       );
                     }
                   },
                   child: const Text(
                     "Update",
                   ),
                 ),
                 MaterialButton(
                     shape: RoundedRectangleBorder(
                       side: const BorderSide(color: AppColors.primaryColor),
                       borderRadius: BorderRadius.circular(12),
                     ),
                     textColor: AppColors.primaryColor,
                     splashColor: AppColors.primaryColor,
                     onPressed: () {
                       SystemNavigator.pop();
                     },
                     child: const Text("Cancel"))
               ],
             ),
           );
         },
       );
     }
   }


 }

 Future<void> _deleteCacheDir(String currentAppVersion) async {
   isLoading.value = true;

   try {
     final cacheDir = await getTemporaryDirectory();
     if (cacheDir.existsSync()) {
       cacheDir.deleteSync(recursive: true);
       //  print("Cache deleted.......................................................................");
     }
     final appDir = await getApplicationSupportDirectory();
     if (appDir.existsSync()) {
       appDir.deleteSync(recursive: true);
       // print("Data deleted.......................................................................");
     }
     LocalServices.storeAppVersion(currentAppVersion);
   } finally {
     isLoading.value = false;
     reloadData();
   }
 }
*/

}
