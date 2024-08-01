// To parse this JSON data, do
//
//     final tripHistoryDetailsModel = tripHistoryDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/single_address_model.dart';

TripHistoryDetailsModel tripHistoryDetailsModelFromJson(String str) => TripHistoryDetailsModel.fromJson(json.decode(str));

String tripHistoryDetailsModelToJson(TripHistoryDetailsModel data) => json.encode(data.toJson());

class TripHistoryDetailsModel {
  final String? status;
  final String? message;
  final Data? data;

  TripHistoryDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory TripHistoryDetailsModel.fromJson(Map<String, dynamic> json) => TripHistoryDetailsModel(
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
  final int? id;
  final String? orderType;
  final String? deliveryCharge;
  final String? riderFee;
  final String? shippingStatus;
  final String? distance;
  final String? duration;
  final DateTime? acceptedAt;
  final DateTime? deliveredAt;
  final RequestFrom? requestFrom;
  final SingleAddressModel? pickupLocation;
  final SingleAddressModel? dropOffLocation;

  Data({
    this.id,
    this.orderType,
    this.deliveryCharge,
    this.riderFee,
    this.shippingStatus,
    this.distance,
    this.duration,
    this.acceptedAt,
    this.deliveredAt,
    this.requestFrom,
    this.pickupLocation,
    this.dropOffLocation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    orderType: json["order_type"],
    deliveryCharge: json["delivery_charge"],
    riderFee: json["rider_fee"],
    shippingStatus: json["shipping_status"],
    distance: json["distance"],
    duration: json["duration"],
    acceptedAt: json["accepted_at"] == null ? null : DateTime.parse(json["accepted_at"]),
    deliveredAt: json["delivered_at"] == null ? null : DateTime.parse(json["delivered_at"]),
    requestFrom: json["requestFrom"] == null ? null : RequestFrom.fromJson(json["requestFrom"]),
    pickupLocation: json["pickupLocation"] == null ? null : SingleAddressModel.fromJson(json["pickupLocation"]),
    dropOffLocation: json["dropOffLocation"] == null ? null : SingleAddressModel.fromJson(json["dropOffLocation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_type": orderType,
    "delivery_charge": deliveryCharge,
    "rider_fee": riderFee,
    "shipping_status": shippingStatus,
    "distance": distance,
    "duration": duration,
    "accepted_at": acceptedAt?.toIso8601String(),
    "delivered_at": deliveredAt?.toIso8601String(),
    "requestFrom": requestFrom?.toJson(),
    "pickupLocation": pickupLocation?.toJson(),
    "dropOffLocation": dropOffLocation?.toJson(),
  };
}

class RequestFrom {
  final dynamic id;
  final dynamic name;
  final dynamic url;

  RequestFrom({
    this.id,
    this.name,
    this.url,
  });

  factory RequestFrom.fromJson(Map<String, dynamic> json) => RequestFrom(
    id: json["id"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
  };
}
