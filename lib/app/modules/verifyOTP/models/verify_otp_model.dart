// To parse this JSON data, do
//
//     final verifyOtpModel = verifyOtpModelFromJson(jsonString);

import 'dart:convert';

import '../../../../models/rider_model.dart';

VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel {
  final String? status;
  final String? message;
  final Data? data;

  VerifyOtpModel({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final String? sessionId;
  final RiderModel? rider;

  Data({
    this.sessionId,
    this.rider,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sessionId: json["session_id"],
    rider: json["rider"] == null ? null : RiderModel.fromJson(json["rider"]),
  );

  Map<String, dynamic> toJson() => {
    "session_id": sessionId,
    "rider": rider?.toJson(),
  };
}

