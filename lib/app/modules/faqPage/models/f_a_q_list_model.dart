// To parse this JSON data, do
//
//     final faqListModel = faqListModelFromJson(jsonString);

import 'dart:convert';

FaqListModel faqListModelFromJson(String str) => FaqListModel.fromJson(json.decode(str));

String faqListModelToJson(FaqListModel data) => json.encode(data.toJson());

class FaqListModel {
  final String? message;
  final String? status;
  final RAQData? data;

  FaqListModel({
    this.message,
    this.status,
    this.data,
  });

  factory FaqListModel.fromJson(Map<String, dynamic> json) => FaqListModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? null : RAQData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data?.toJson(),
  };
}

class RAQData {
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
  final List<SingleFAQModel>? data;

  RAQData({
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

  factory RAQData.fromJson(Map<String, dynamic> json) => RAQData(
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
    data: json["data"] == null ? [] : List<SingleFAQModel>.from(json["data"]!.map((x) => SingleFAQModel.fromJson(x))),
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

class SingleFAQModel {
  final int? id;
  final String? type;
  final String? faqQuestion;
  final String? faqAns;
  final dynamic serial;
  final dynamic createdAt;
  final dynamic updatedAt;

  SingleFAQModel({
    this.id,
    this.type,
    this.faqQuestion,
    this.faqAns,
    this.serial,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleFAQModel.fromJson(Map<String, dynamic> json) => SingleFAQModel(
    id: json["id"],
    type: json["type"],
    faqQuestion: json["faq_question"],
    faqAns: json["faq_ans"],
    serial: json["serial"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "faq_question": faqQuestion,
    "faq_ans": faqAns,
    "serial": serial,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
