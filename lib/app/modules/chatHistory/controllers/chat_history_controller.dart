import 'package:cgp_driver_app/app/modules/chatHistory/models/chat_history_model.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatHistoryController extends GetxController {
  var isLoading = false.obs;
  var rider = RiderModel().obs;
  var chatHistoryModel=ChatHistoryModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getRider();
    getChatHistory();
  }


  @override
  void onClose() {}

  Future<void> getChatHistory() async {
    isLoading.value=true;
    //var link = "https://cgp.studypress.org/api/v1/messaging/ajax/get-user-list?&sender_id=${rider.value.userId}";
    var link = "${APIEndPoints.baseUrlMessaging}/api/v1/messaging/ajax/get-user-list?&sender_id=${rider.value.userId}";
    try {
      var response= await RemoteServices.chatGetRequest(link: link);

      if(response!=null){
        if (kDebugMode) {
          chatHistoryModel.value=ChatHistoryModel.fromJson(response);
        }
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void> getRider() async {
    rider.value = await LocalServices.getUser() ?? RiderModel();
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      // Return time if the date is today
      return DateFormat.jm().format(dateTime); // Format: 8:05 PM
    } else {
      // Return date if the date is not today
      return DateFormat.MMMd().format(dateTime); // Format: Jul 16
    }
  }

  Future<void>changeStatus({required String orderId,required String receiverId})async{
   // var url="https://cgp.studypress.org/api/v1/messaging/ajax/update-message-status";
    var url="${APIEndPoints.baseUrlMessaging}/api/v1/messaging/ajax/update-message-status";
    var body={
      "order_id":orderId,
      "receiver_id":receiverId
    };
    var response=await RemoteServices.chatPostRequest(url: url,body: body);
    if(response!=null){
     getChatHistory();
    }
  }
}
