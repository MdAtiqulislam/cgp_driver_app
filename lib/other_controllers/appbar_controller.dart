import 'package:cgp_driver_app/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:cgp_driver_app/app/modules/notifications/models/notifications_model.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:get/get.dart';

import '../app/routes/app_pages.dart';

class AppbarController extends GetxController{
  var riderModel=RiderModel().obs;

  var isLoading=false.obs;
  var notificationsModel=NotificationsModel().obs;
  var unreadNotifications=0.obs;


  @override
  void onInit() async{
    super.onInit();
    await getUserData();
  }

 Future<void> getUserData() async{
    await LocalServices.getUser().then((value) async {
      if(value!=null){
        riderModel.value=value;
        if(riderModel.value.id!=null){
          await getNotifications();
        }
      }
    });
 }

 Future<void>getNotifications()async{

    var endPoint=APIEndPoints.getNotifications;
    try {
      var data=await RemoteServices.getRequest(endPoint: endPoint);
      if(data!=null){
        unreadNotifications.value=0;
        notificationsModel.value=NotificationsModel.fromJson(data);

        Get.put(NotificationsController());
        Get.find<NotificationsController>().notificationsModel.value=notificationsModel.value;

        notificationsModel.value.data?.forEach((value){
          if(!(value.isRead??true)){
            unreadNotifications.value+=1;
          }
        });
      }
    } finally {
     isLoading.value=false;
    }
 }

  void calculateUnreadNotification() {
    print("Calculating.......");
    unreadNotifications.value=0;
    notificationsModel.value.data?.forEach((value){
      if(!(value.isRead??true)){
        unreadNotifications.value+=1;
      }
    });
    print(unreadNotifications);
  }

  void openNotificationPage() {


    if(Get.currentRoute==Routes.NOTIFICATIONS){
      Get.offAndToNamed(Routes.NOTIFICATIONS);
    }else{
      Get.put(NotificationsController());
      Get.find<NotificationsController>()
          .getNotifications();
      Get.toNamed(Routes.NOTIFICATIONS);
    }


  }

}