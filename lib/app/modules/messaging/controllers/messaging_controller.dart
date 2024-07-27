import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:cgp_driver_app/common_widgets/custom_snackbar.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/models/load_message_model.dart';
import 'package:cgp_driver_app/models/message_data_model.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/pusher_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/send_message_response_model.dart';

class MessagingController extends GetxController {
  var imageLink = "".obs;
  var chatWith = "".obs;
  var rider = RiderModel().obs;
  var isLoading=false.obs;

  var messages = <MessageDataModel>[].obs;
  var messageController = TextEditingController();
  var sendMessageResponseModel = SendMessageResponseModel();
  var loadMessageResponseModel = LoadMessageModel();

  late PusherService messageService;

  var orderDetails = TripRequestDetailsModel().obs;
  String? senderId;
  String? receiverId;
  String? orderId;
  String? replayById;
  String? replayToId;
  var disableChat=false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    rider.value = await LocalServices.getUser() ?? RiderModel();
  }

  void fetchMessages(String senderId) async {
    try {
      // var fetchedMessages = await messageService.fetchMessagesBySenderId(senderId);
      //  messages.assignAll(fetchedMessages);
    } catch (e) {
      print('Failed to load messages: $e');
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text;
    var url="https://cgp.studypress.org/api/v1/messaging/ajax/send-message";
    if (text.isNotEmpty) {
      var body = {
        "sender_id": senderId??rider.value.userId,
        "receiver_id": receiverId??orderDetails.value.data?.requestFrom?.userId,
        "order_id": orderId??orderDetails.value.data?.orderId,
        "reply_by_id": replayById??orderDetails.value.data?.assignedRider?.id,
        "reply_to_id": replayToId??orderDetails.value.data?.requestFrom?.id,
        "reply_by_type_id": 23,
        "reply_to_type_id": 24,
        "message": text,
      };
      // Add the new message to the local list
      messageController.clear();
      try {
        var response = await RemoteServices.chatPostRequest(url:url,body: body);
        if (response != null) {
          sendMessageResponseModel =
              SendMessageResponseModel.fromJson(response);
          messages.add(sendMessageResponseModel.data ?? MessageDataModel());


        } else {
          CustomSnackBar(isSuccess: false, msg: AppStrings.httpErrorMSG.value)
              .showSnackBar();
        }
      } finally {}
    }
  }



  Future<void> loadPreviousMessage() async {

    messages.value=[];
    isLoading.value=true;
    var link="https://cgp.studypress.org/api/v1/messaging/ajax/get-message-list";
    var parameters={
    "senderId": senderId??rider.value.userId.toString(),
    "receiverId": receiverId??orderDetails.value.data?.requestFrom?.userId.toString(),
    "orderId": orderId??orderDetails.value.data?.orderId.toString(),
    };
    try {
      var response=await RemoteServices.chatGetRequest(link: link,parameters: parameters);
      if(response!=null){
        loadMessageResponseModel=LoadMessageModel.fromJson(response);
        loadMessageResponseModel.data?.forEach((value){
          messages.value.add(value);
        });

      }
    } finally {
      isLoading.value=false;
    }
  }



  void initValue(){
     senderId=null;
     receiverId=null;
    orderId=null;
    replayById=null;
    replayToId=null;
  }


}
