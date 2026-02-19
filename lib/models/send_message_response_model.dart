
import 'dart:convert';

import 'message_data_model.dart';


SendMessageResponseModel sendMessageResponseModelFromJson(String str) => SendMessageResponseModel.fromJson(json.decode(str));

String sendMessageResponseModelToJson(SendMessageResponseModel data) => json.encode(data.toJson());

class SendMessageResponseModel {
  final String? message;
  final String? status;
  final MessageDataModel? data;

  SendMessageResponseModel({
    this.message,
    this.status,
    this.data,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) => SendMessageResponseModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? null : MessageDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data?.toJson(),
  };
}

