// To parse this JSON data, do
//
//     final riderProfileUpdateModel = riderProfileUpdateModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/rider_model.dart';

RiderProfileUpdateModel riderProfileUpdateModelFromJson(String str) => RiderProfileUpdateModel.fromJson(json.decode(str));

String riderProfileUpdateModelToJson(RiderProfileUpdateModel data) => json.encode(data.toJson());

class RiderProfileUpdateModel {
  final String? status;
  final String? message;
  final RiderModel? data;

  RiderProfileUpdateModel({
    this.status,
    this.message,
    this.data,
  });

  factory RiderProfileUpdateModel.fromJson(Map<String, dynamic> json) => RiderProfileUpdateModel(
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

