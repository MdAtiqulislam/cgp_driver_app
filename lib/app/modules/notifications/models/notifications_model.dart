
import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  final String? status;
  final String? message;
  final List<SingleNotificationModel>? data;

  NotificationsModel({
    this.status,
    this.message,
    this.data,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SingleNotificationModel>.from(json["data"]!.map((x) => SingleNotificationModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleNotificationModel {
  final String? id;
  final String? deviceToken;
  final int? userId;
  final String? title;
  final String? message;
  final NotificationData? data;
  final bool? isRead;
  final DateTime? createdAt;
  final int? v;

  SingleNotificationModel({
    this.id,
    this.deviceToken,
    this.userId,
    this.title,
    this.message,
    this.data,
    this.isRead,
    this.createdAt,
    this.v,
  });

  factory SingleNotificationModel.fromJson(Map<String, dynamic> json) => SingleNotificationModel(
    id: json["_id"],
    deviceToken: json["deviceToken"],
    userId: json["userId"],
    title: json["title"],
    message: json["message"],
    data: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
    isRead: json["isRead"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "deviceToken": deviceToken,
    "userId": userId,
    "title": title,
    "message": message,
    "data": data?.toJson(),
    "isRead": isRead,
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };
}

class NotificationData {
  final String? target;
  final String? type;
  final String? requestId;
  final String? requestedByUserId;
  final String? requestedByUserName;
  final String? riderId;

  NotificationData({
    this.target,
    this.type,
    this.requestId,
    this.requestedByUserId,
    this.requestedByUserName,
    this.riderId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    target: json["target"],
    type: json["type"],
    requestId: json["requestId"],
    requestedByUserId: json["requestedByUserId"],
    requestedByUserName: json["requestedByUserName"],
    riderId: json["riderId"],
  );

  Map<String, dynamic> toJson() => {
    "target": target,
    "type": type,
    "requestId": requestId,
    "requestedByUserId": requestedByUserId,
    "requestedByUserName": requestedByUserName,
    "riderId": riderId,
  };
}
