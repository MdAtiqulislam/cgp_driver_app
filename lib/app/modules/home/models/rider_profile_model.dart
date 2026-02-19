// To parse this JSON data, do
//
//     final riderProfileModel = riderProfileModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/rider_model.dart';

RiderProfileModel riderProfileModelFromJson(String str) => RiderProfileModel.fromJson(json.decode(str));

String riderProfileModelToJson(RiderProfileModel data) => json.encode(data.toJson());

class RiderProfileModel {
  final String? status;
  final String? message;
  final RiderModel? data;

  RiderProfileModel({
    this.status,
    this.message,
    this.data,
  });

  factory RiderProfileModel.fromJson(Map<String, dynamic> json) => RiderProfileModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : RiderModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

