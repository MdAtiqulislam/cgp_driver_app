// To parse this JSON data, do
//
//     final todaysEarningHistoryModel = todaysEarningHistoryModelFromJson(jsonString);

import 'dart:convert';

TodaysEarningHistoryModel todaysEarningHistoryModelFromJson(String str) => TodaysEarningHistoryModel.fromJson(json.decode(str));

String todaysEarningHistoryModelToJson(TodaysEarningHistoryModel data) => json.encode(data.toJson());

class TodaysEarningHistoryModel {
  final String? message;
  final String? status;
  final TodaysEarningData? data;

  TodaysEarningHistoryModel({
    this.message,
    this.status,
    this.data,
  });

  factory TodaysEarningHistoryModel.fromJson(Map<String, dynamic> json) => TodaysEarningHistoryModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? null : TodaysEarningData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data?.toJson(),
  };
}

class TodaysEarningData {
  final int? totalTrips;
  final int? totalDistance;
  final int? totalEarnings;
  final int? totalTripTime;

  TodaysEarningData({
    this.totalTrips,
    this.totalDistance,
    this.totalEarnings,
    this.totalTripTime,
  });

  factory TodaysEarningData.fromJson(Map<String, dynamic> json) => TodaysEarningData(
    totalTrips: json["total_trips"],
    totalDistance: json["total_distance"],
    totalEarnings: json["total_earnings"],
    totalTripTime: json["total_trip_time"],
  );

  Map<String, dynamic> toJson() => {
    "total_trips": totalTrips,
    "total_distance": totalDistance,
    "total_earnings": totalEarnings,
    "total_trip_time": totalTripTime,
  };
}
