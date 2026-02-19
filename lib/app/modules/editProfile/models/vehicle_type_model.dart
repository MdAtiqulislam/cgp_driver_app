// To parse this JSON data, do
//
//     final vehicleTypeModel = vehicleTypeModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/single_vehicle_type_model.dart';

VehicleTypeModel vehicleTypeModelFromJson(String str) => VehicleTypeModel.fromJson(json.decode(str));

String vehicleTypeModelToJson(VehicleTypeModel data) => json.encode(data.toJson());

class VehicleTypeModel {
  final String? status;
  final String? message;
  final List<SingleVehicleTypeModel>? data;

  VehicleTypeModel({
    this.status,
    this.message,
    this.data,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SingleVehicleTypeModel>.from(json["data"]!.map((x) => SingleVehicleTypeModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

