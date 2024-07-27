// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

import 'message_data_model.dart';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  final MessageDataModel? message;

  MessageModel({
    this.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    message: json["message"] == null ? null : MessageDataModel.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message?.toJson(),
  };
}


