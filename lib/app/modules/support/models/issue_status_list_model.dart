// To parse this JSON data, do
//
//     final issueSubjectListModel = issueSubjectListModelFromJson(jsonString);

import 'dart:convert';

IssueSubjectListModel issueSubjectListModelFromJson(String str) => IssueSubjectListModel.fromJson(json.decode(str));

String issueSubjectListModelToJson(IssueSubjectListModel data) => json.encode(data.toJson());

class IssueSubjectListModel {
  final String? message;
  final String? status;
  final List<SingleIssueSubjectModel>? data;

  IssueSubjectListModel({
    this.message,
    this.status,
    this.data,
  });

  factory IssueSubjectListModel.fromJson(Map<String, dynamic> json) => IssueSubjectListModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleIssueSubjectModel>.from(json["data"]!.map((x) => SingleIssueSubjectModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleIssueSubjectModel {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SingleIssueSubjectModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleIssueSubjectModel.fromJson(Map<String, dynamic> json) => SingleIssueSubjectModel(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
