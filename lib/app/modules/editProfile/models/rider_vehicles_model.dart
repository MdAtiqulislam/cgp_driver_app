// To parse this JSON data, do
//
//     final riderVehiclesModel = riderVehiclesModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/single_vehicle_model.dart';

RiderVehiclesModel riderVehiclesModelFromJson(String str) => RiderVehiclesModel.fromJson(json.decode(str));

String riderVehiclesModelToJson(RiderVehiclesModel data) => json.encode(data.toJson());

class RiderVehiclesModel {
  final String? status;
  final String? message;
  final List<SingleVehicleModel>? data;

  RiderVehiclesModel({
    this.status,
    this.message,
    this.data,
  });

  factory RiderVehiclesModel.fromJson(Map<String, dynamic> json) => RiderVehiclesModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SingleVehicleModel>.from(json["data"]!.map((x) => SingleVehicleModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}


