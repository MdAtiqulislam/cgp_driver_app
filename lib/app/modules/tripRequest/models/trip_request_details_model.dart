// To parse this JSON data, do
//
//     final tripRequestDetailsModel = tripRequestDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/single_address_model.dart';

TripRequestDetailsModel tripRequestDetailsModelFromJson(String str) => TripRequestDetailsModel.fromJson(json.decode(str));

String tripRequestDetailsModelToJson(TripRequestDetailsModel data) => json.encode(data.toJson());

class TripRequestDetailsModel {
  final String? status;
  final String? message;
  final TripDetailsData? data;

  TripRequestDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory TripRequestDetailsModel.fromJson(Map<String, dynamic> json) => TripRequestDetailsModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : TripDetailsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class TripDetailsData {
  final String? id;
  final RequestFrom? requestFrom;
  final SingleAddressModel? pickupLocation;
  final SingleAddressModel? dropOffLocation;
  final String? totalDistance;
  final String? totalWeight;
  final String? deliveryCost;
  final String? riderFee;
  final String? estimatedArrivalTime;
  final int? orderId;
  final String? stripeId;
  final int? deliveryId;
  final String? orderType;
  final String? status;
  final AssignedRider? assignedRider;
  final int? v;

  TripDetailsData({
    this.id,
    this.requestFrom,
    this.pickupLocation,
    this.dropOffLocation,
    this.totalDistance,
    this.totalWeight,
    this.deliveryCost,
    this.riderFee,
    this.estimatedArrivalTime,
    this.orderId,
    this.stripeId,
    this.deliveryId,
    this.orderType,
    this.status,
    this.assignedRider,
    this.v,
  });

  factory TripDetailsData.fromJson(Map<String, dynamic> json) => TripDetailsData(
    id: json["_id"],
    requestFrom: json["requestFrom"] == null ? null : RequestFrom.fromJson(json["requestFrom"]),
    pickupLocation: json["pickupLocation"] == null ? null : SingleAddressModel.fromJson(json["pickupLocation"]),
    dropOffLocation: json["dropOffLocation"] == null ? null : SingleAddressModel.fromJson(json["dropOffLocation"]),
    totalDistance: json["totalDistance"],
    totalWeight: json["totalWeight"],
    deliveryCost: json["deliveryCost"],
    riderFee: json["riderFee"],
    estimatedArrivalTime: json["estimatedArrivalTime"],
    orderId: json["orderId"],
    stripeId: json["stripeId"],
    deliveryId: json["deliveryId"],
    orderType: json["orderType"],
    status: json["status"],
    assignedRider: json["assignedRider"] == null ? null : AssignedRider.fromJson(json["assignedRider"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "requestFrom": requestFrom?.toJson(),
    "pickupLocation": pickupLocation?.toJson(),
    "dropOffLocation": dropOffLocation?.toJson(),
    "totalDistance": totalDistance,
    "totalWeight": totalWeight,
    "deliveryCost": deliveryCost,
    "riderFee": riderFee,
    "estimatedArrivalTime": estimatedArrivalTime,
    "orderId": orderId,
    "stripeId": stripeId,
    "deliveryId": deliveryId,
    "orderType": orderType,
    "status": status,
    "assignedRider": assignedRider?.toJson(),
    "__v": v,
  };
}

class AssignedRider {
  final int? id;
  final String? name;
  final int? vehicleId;

  AssignedRider({
    this.id,
    this.name,
    this.vehicleId,
  });

  factory AssignedRider.fromJson(Map<String, dynamic> json) => AssignedRider(
    id: json["id"],
    name: json["name"],
    vehicleId: json["vehicleId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "vehicleId": vehicleId,
  };
}

class RequestFrom {
  final int? id;
  final int? userId;
  final String? name;
  final dynamic url;
  final AvgRating? avgRating;

  RequestFrom({
    this.id,
    this.name,
    this.userId,
    this.url,
    this.avgRating,
  });

  factory RequestFrom.fromJson(Map<String, dynamic> json) => RequestFrom(
    id: json["id"],
    userId: json["userId"],
    name: json["name"],
    url: json["url"],
    avgRating: json["avg_rating"] == null ? null : AvgRating.fromJson(json["avg_rating"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "name": name,
    "url": url,
    "avg_rating": avgRating?.toJson(),
  };
}

class AvgRating {
  final dynamic averageRating;
  final dynamic totalRatings;
  AvgRating({
    this.averageRating,
    this.totalRatings,
  });

  factory AvgRating.fromJson(Map<String, dynamic> json) => AvgRating(
    averageRating: json["average_rating"],
    totalRatings: json["total_ratings"],
  );

  Map<String, dynamic> toJson() => {
    "average_rating": averageRating,
    "total_ratings": totalRatings,
  };
}
