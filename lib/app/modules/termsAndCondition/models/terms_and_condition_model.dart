// To parse this JSON data, do
//
//     final termsAndConditionModel = termsAndConditionModelFromJson(jsonString);

import 'dart:convert';

TermsAndConditionModel termsAndConditionModelFromJson(String str) => TermsAndConditionModel.fromJson(json.decode(str));

String termsAndConditionModelToJson(TermsAndConditionModel data) => json.encode(data.toJson());

class TermsAndConditionModel {
  final String? message;
  final String? status;
  final List<TermsAndConditionData>? data;

  TermsAndConditionModel({
    this.message,
    this.status,
    this.data,
  });

  factory TermsAndConditionModel.fromJson(Map<String, dynamic> json) => TermsAndConditionModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? [] : List<TermsAndConditionData>.from(json["data"]!.map((x) => TermsAndConditionData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TermsAndConditionData {
  final int? id;
  final String? info;
  final String? type;
  final dynamic createdAt;
  final dynamic updatedAt;

  TermsAndConditionData({
    this.id,
    this.info,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory TermsAndConditionData.fromJson(Map<String, dynamic> json) => TermsAndConditionData(
    id: json["id"],
    info: json["info"],
    type: json["type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "info": info,
    "type": type,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
