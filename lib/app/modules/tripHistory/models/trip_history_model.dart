/*
// To parse this JSON data, do
//
//     final tripHistoryModel = tripHistoryModelFromJson(jsonString);

import 'dart:convert';

TripHistoryModel tripHistoryModelFromJson(String str) => TripHistoryModel.fromJson(json.decode(str));

String tripHistoryModelToJson(TripHistoryModel data) => json.encode(data.toJson());

class TripHistoryModel {
  final String? status;
  final String? message;
  final List<SingleTripHistoryModel>? data;

  TripHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) => TripHistoryModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SingleTripHistoryModel>.from(json["data"]!.map((x) => SingleTripHistoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleTripHistoryModel {
  final int? id;
  final String? orderType;
  final String? warehouseId;
  final String? warehouseName;
  final dynamic customerId;
  final dynamic customerFirstName;
  final dynamic customerLastName;
  final int? deliveryCharge;
  final String? shippingStatus;
  final DateTime? acceptedAt;
  final DateTime? deliveredAt;
  final RequestFrom? requestFrom;

  SingleTripHistoryModel({
    this.id,
    this.orderType,
    this.warehouseId,
    this.warehouseName,
    this.customerId,
    this.customerFirstName,
    this.customerLastName,
    this.deliveryCharge,
    this.shippingStatus,
    this.acceptedAt,
    this.deliveredAt,
    this.requestFrom,
  });

  factory SingleTripHistoryModel.fromJson(Map<String, dynamic> json) => SingleTripHistoryModel(
    id: json["id"],
    orderType: json["order_type"],
    warehouseId: json["warehouse_id"],
    warehouseName: json["warehouse_name"],
    customerId: json["customer_id"],
    customerFirstName: json["customer_first_name"],
    customerLastName: json["customer_last_name"],
    deliveryCharge: json["delivery_charge"],
    shippingStatus: "shipping_status",
    acceptedAt: json["accepted_at"] == null ? null : DateTime.parse(json["accepted_at"]),
    deliveredAt: json["delivered_at"] == null ? null : DateTime.parse(json["delivered_at"]),
    requestFrom: json["requestFrom"] == null ? null : RequestFrom.fromJson(json["requestFrom"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_type": orderType,
    "warehouse_id": warehouseId,
    "warehouse_name": warehouseName,
    "customer_id": customerId,
    "customer_first_name": customerFirstName,
    "customer_last_name": customerLastName,
    "delivery_charge": deliveryCharge,
    "shipping_status": shippingStatus,
    "accepted_at": acceptedAt?.toIso8601String(),
    "delivered_at": deliveredAt?.toIso8601String(),
    "requestFrom": requestFrom?.toJson(),
  };
}

class RequestFrom {
  final dynamic id;
  final String? name;
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

*/


// To parse this JSON data, do
//
//     final tripHistoryModel = tripHistoryModelFromJson(jsonString);

import 'dart:convert';

import '../../../../models/reviews_model.dart';

TripHistoryModel tripHistoryModelFromJson(String str) => TripHistoryModel.fromJson(json.decode(str));

String tripHistoryModelToJson(TripHistoryModel data) => json.encode(data.toJson());

class TripHistoryModel {
  final String? status;
  final String? message;
  final List<SingleTripHistoryModel>? data;

  TripHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) => TripHistoryModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SingleTripHistoryModel>.from(json["data"]!.map((x) => SingleTripHistoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleTripHistoryModel {
  final int? id;
  final RequestFrom? requestFrom;
  final int? orderId;
  final String? orderType;
  final String? shippingStatus;
  final String? deliveryCharge;
  final String? riderFee;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final dynamic cancelledAt;
  final ReviewsModel? reviews;

  SingleTripHistoryModel({
    this.id,
    this.requestFrom,
    this.orderId,
    this.orderType,
    this.shippingStatus,
    this.deliveryCharge,
    this.riderFee,
    this.acceptedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.cancelledAt,
    this.reviews,
  });

  factory SingleTripHistoryModel.fromJson(Map<String, dynamic> json) => SingleTripHistoryModel(
    id: json["id"],
    requestFrom: json["requestFrom"] == null ? null : RequestFrom.fromJson(json["requestFrom"]),
    orderId: json["order_id"],
    orderType: json["order_type"],
    shippingStatus: json["shipping_status"],
    deliveryCharge: json["delivery_charge"],
    riderFee: json["rider_fee"],
    acceptedAt: json["accepted_at"] == null ? null : DateTime.parse(json["accepted_at"]),
    pickedUpAt: json["picked_up_at"] == null ? null : DateTime.parse(json["picked_up_at"]),
    deliveredAt: json["delivered_at"] == null ? null : DateTime.parse(json["delivered_at"]),
    cancelledAt: json["cancelled_at"],
    reviews: json["reviews"] == null ? null : ReviewsModel.fromJson(json["reviews"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "requestFrom": requestFrom?.toJson(),
    "order_id": orderId,
    "order_type": orderType,
    "shipping_status": shippingStatus,
    "delivery_charge": deliveryCharge,
    "rider_fee": riderFee,
    "accepted_at": acceptedAt?.toIso8601String(),
    "picked_up_at": pickedUpAt?.toIso8601String(),
    "delivered_at": deliveredAt?.toIso8601String(),
    "cancelled_at": cancelledAt,
    "reviews": reviews?.toJson(),
  };
}

class RequestFrom {
  final int? id;
  final String? name;
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


