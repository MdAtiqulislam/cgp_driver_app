// To parse this JSON data, do
//
//     final loginVerificationModel = loginVerificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/rider_model.dart';

LoginVerificationModel loginVerificationModelFromJson(String str) => LoginVerificationModel.fromJson(json.decode(str));

String loginVerificationModelToJson(LoginVerificationModel data) => json.encode(data.toJson());

class LoginVerificationModel {
  final String? status;
  final String? message;
  final Data? data;

  LoginVerificationModel({
    this.status,
    this.message,
    this.data,
  });

  factory LoginVerificationModel.fromJson(Map<String, dynamic> json) => LoginVerificationModel(
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
  final RiderModel? rider;
  final String? accessToken;

  Data({
    this.rider,
    this.accessToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    rider: json["rider"] == null ? null : RiderModel.fromJson(json["rider"]),
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "rider": rider?.toJson(),
    "access_token": accessToken,
  };
}

