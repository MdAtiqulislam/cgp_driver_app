// To parse this JSON data, do
//
//     final issueListModel = issueListModelFromJson(jsonString);

import 'dart:convert';

IssueListModel issueListModelFromJson(String str) => IssueListModel.fromJson(json.decode(str));

String issueListModelToJson(IssueListModel data) => json.encode(data.toJson());

class IssueListModel {
  final String? message;
  final String? status;
  final IssueData? data;

  IssueListModel({
    this.message,
    this.status,
    this.data,
  });

  factory IssueListModel.fromJson(Map<String, dynamic> json) => IssueListModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? null : IssueData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data?.toJson(),
  };
}

class IssueData {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final dynamic nextPageUrl;
  final dynamic prevPageUrl;
  final String? path;
  final int? from;
  final int? to;
  final List<SingleIssueModel>? data;

  IssueData({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.path,
    this.from,
    this.to,
    this.data,
  });

  factory IssueData.fromJson(Map<String, dynamic> json) => IssueData(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    firstPageUrl: json["first_page_url"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
    path: json["path"],
    from: json["from"],
    to: json["to"],
    data: json["data"] == null ? [] : List<SingleIssueModel>.from(json["data"]!.map((x) => SingleIssueModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "first_page_url": firstPageUrl,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
    "path": path,
    "from": from,
    "to": to,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleIssueModel {
  final int? id;
  final String? ticketId;
  final int? issuedById;
  final int? issuedByTypeId;
  final int? issuedToId;
  final int? issuedToTypeId;
  final int? supportStatusId;
  final String? subject;
  final String? description;

  final CurrentStatus? currentStatus;

  SingleIssueModel({
    this.id,
    this.ticketId,
    this.issuedById,
    this.issuedByTypeId,
    this.issuedToId,
    this.issuedToTypeId,
    this.supportStatusId,
    this.subject,
    this.description,
    this.currentStatus,
  });

  factory SingleIssueModel.fromJson(Map<String, dynamic> json) => SingleIssueModel(
    id: json["id"],
    ticketId: json["ticket_id"],
    issuedById: json["issued_by_id"],
    issuedByTypeId: json["issued_by_type_id"],
    issuedToId: json["issued_to_id"],
    issuedToTypeId: json["issued_to_type_id"],
    supportStatusId: json["support_status_id"],
    subject: json["subject"],
    description: json["description"],
     currentStatus: json["current_status"] == null ? null : CurrentStatus.fromJson(json["current_status"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticket_id": ticketId,
    "issued_by_id": issuedById,
    "issued_by_type_id": issuedByTypeId,
    "issued_to_id": issuedToId,
    "issued_to_type_id": issuedToTypeId,
    "support_status_id": supportStatusId,
    "subject": subject,
    "description": description,
   "current_status": currentStatus?.toJson(),
  };
}

class CurrentStatus {
  final int? id;
  final int? statusGroupId;
  final String? name;
  final String? code;
  final dynamic value;
  final dynamic data;
  final dynamic serial;
  final int? active;
  final int? editable;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  CurrentStatus({
    this.id,
    this.statusGroupId,
    this.name,
    this.code,
    this.value,
    this.data,
    this.serial,
    this.active,
    this.editable,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
    id: json["id"],
    statusGroupId: json["status_group_id"],
    name: json["name"],
    code: json["code"],
    value: json["value"],
    data: json["data"],
    serial: json["serial"],
    active: json["active"],
    editable: json["editable"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status_group_id": statusGroupId,
    "name": name,
    "code": code,
    "value": value,
    "data": data,
    "serial": serial,
    "active": active,
    "editable": editable,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
  };
}

