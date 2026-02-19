// To parse this JSON data, do
//
//     final bankHistoryModel = bankHistoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/bank_info_model.dart';

BankHistoryModel bankHistoryModelFromJson(String str) => BankHistoryModel.fromJson(json.decode(str));

String bankHistoryModelToJson(BankHistoryModel data) => json.encode(data.toJson());

class BankHistoryModel {
  final String? status;
  final String? message;
  final List<BankInfoModel>? data;

  BankHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory BankHistoryModel.fromJson(Map<String, dynamic> json) => BankHistoryModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<BankInfoModel>.from(json["data"]!.map((x) => BankInfoModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}


