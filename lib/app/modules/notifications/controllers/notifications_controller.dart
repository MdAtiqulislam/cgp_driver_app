import 'package:cgp_driver_app/app/modules/notifications/models/notifications_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:get/get.dart';

import '../../../../other_controllers/appbar_controller.dart';
import '../../../routes/app_pages.dart';
import '../../tripRequest/controllers/trip_request_controller.dart';

class NotificationsController extends GetxController {
  var isLoading = false.obs;
  var notificationsModel = NotificationsModel().obs;

  @override
  void onClose() {}

  Future<void> getNotifications() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.getNotifications;
    try {
      var response = await RemoteServices.getRequest(endPoint: endPoint);
      if (response != null) {
        notificationsModel.value = NotificationsModel.fromJson(response);
        Get.find<AppbarController>().notificationsModel.value =
            notificationsModel.value;
        Get.find<AppbarController>().calculateUnreadNotification();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void handelClick(
      {required String requestedId, required String notificationId}) {
    Get.put(TripRequestController());
    Get.find<TripRequestController>()
        .getTripDetails(requestId: requestedId, notificationId: notificationId);
    Get.toNamed(Routes.TRIP_REQUEST);
    markAsRead(notificationId: notificationId);
  }

  void markAsRead({required String notificationId}) async {
    var endPoint = APIEndPoints.markAsReadNotification
        .replaceAll("{notificationId}", notificationId);
    var response = await RemoteServices.putRequest(endPoint: endPoint);
    if (response != null) {
      await getNotifications().then((value) {
        Get.find<AppbarController>().notificationsModel.value =
            notificationsModel.value;
        Get.find<AppbarController>().calculateUnreadNotification();
      });
    }
  }

  void deleteNotificationById(String id, int index) {
    var endPoint =
        APIEndPoints.deleteNotificationById.replaceAll("{notificationId}", id);
    RemoteServices.deleteRequest(endPoint: endPoint).then((response) {
      if (response != null) {
        notificationsModel.value.data?.removeAt(index);
        Get.find<AppbarController>().notificationsModel.value =
            notificationsModel.value;
        Get.find<AppbarController>().calculateUnreadNotification();
      }
    });
  }

  Future<void> markAllAsRead() async {
    var endPoint = APIEndPoints.markAllAsReadNotification;
    var response = await RemoteServices.putRequest(endPoint: endPoint);
    if (response != null) {
      await getNotifications().then((value) {
        Get.find<AppbarController>().notificationsModel.value =
            notificationsModel.value;
        Get.find<AppbarController>().calculateUnreadNotification();
      });
    }
  }

 Future <void> deleteAllNotifications() async{
    isLoading.value= true;
    var endPoint = APIEndPoints.deleteAllNotifications;
    try {
      var response = await RemoteServices.deleteRequest(endPoint: endPoint);
      if (response != null) {
        notificationsModel.value.data?.clear();
        Get.find<AppbarController>().notificationsModel.value =
            notificationsModel.value;
        Get.find<AppbarController>().calculateUnreadNotification();
        getNotifications();
      }
    } finally {
      isLoading.value= false;
    }
 }
}

/*Future<void> getNotifications() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.getNotifications;
    try {
      var data = await RemoteServices.getRequest(endPoint: endPoint);
      if (data != null) {
        notificationsModel.value = NotificationsModel.fromJson(data);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void handelClick({required String requestedId,required String notificationId}) {
    Get.put(TripRequestController());
    Get.find<TripRequestController>().getTripDetails(requestId: requestedId,notificationId: notificationId);
    Get.toNamed(Routes.TRIP_REQUEST);
  }
*/
