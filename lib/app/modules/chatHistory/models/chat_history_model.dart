
import 'dart:convert';

ChatHistoryModel chatHistoryModelFromJson(String str) => ChatHistoryModel.fromJson(json.decode(str));

String chatHistoryModelToJson(ChatHistoryModel data) => json.encode(data.toJson());

class ChatHistoryModel {
  final String? message;
  final String? status;
  final List<ChatHistoryData>? data;

  ChatHistoryModel({
    this.message,
    this.status,
    this.data,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) => ChatHistoryModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? [] : List<ChatHistoryData>.from(json["data"]!.map((x) => ChatHistoryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ChatHistoryData {
  final int? id;
  final dynamic warehouseId;
  final int? orderId;
  final int? senderId;
  final int? receiverId;
  final int? replyById;
  final int? replyToId;
  final int? replyByTypeId;
  final int? replyToTypeId;
  final String? message;
  final int? readAt;
  final int? cfMediaStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? maxId;
  final int? unreadCount;
  final Customer? customer;
  final Rider? rider;
  final Warehouse? warehouse;

  ChatHistoryData({
    this.id,
    this.warehouseId,
    this.orderId,
    this.senderId,
    this.receiverId,
    this.replyById,
    this.replyToId,
    this.replyByTypeId,
    this.replyToTypeId,
    this.message,
    this.readAt,
    this.cfMediaStatus,
    this.createdAt,
    this.updatedAt,
    this.maxId,
    this.unreadCount,
    this.customer,
    this.rider,
    this.warehouse,
  });

  factory ChatHistoryData.fromJson(Map<String, dynamic> json) => ChatHistoryData(
    id: json["id"],
    warehouseId: json["warehouse_id"],
    orderId: json["order_id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    replyById: json["reply_by_id"],
    replyToId: json["reply_to_id"],
    replyByTypeId: json["reply_by_type_id"],
    replyToTypeId: json["reply_to_type_id"],
    message: json["message"],
    readAt: json["read_at"],
    cfMediaStatus: json["cf_media_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    maxId: json["max_id"],
    unreadCount: json["unread_count"],
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    rider: json["rider"] == null ? null : Rider.fromJson(json["rider"]),
    warehouse: json["warehouse"] == null ? null : Warehouse.fromJson(json["warehouse"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "warehouse_id": warehouseId,
    "order_id": orderId,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "reply_by_id": replyById,
    "reply_to_id": replyToId,
    "reply_by_type_id": replyByTypeId,
    "reply_to_type_id": replyToTypeId,
    "message": message,
    "read_at": readAt,
    "cf_media_status": cfMediaStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "max_id": maxId,
    "unread_count": unreadCount,
    "customer": customer?.toJson(),
    "rider": rider?.toJson(),
    "warehouse": warehouse?.toJson(),
  };
}

class Customer {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final dynamic dateOfBirth;
  final dynamic gender;
  final DateTime? registrationDate;
  final DateTime? lastLogin;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? phone;
  final String? email;
  final dynamic profileImageCfMediaId;

  Customer({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.registrationDate,
    this.lastLogin,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.email,
    this.profileImageCfMediaId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    dateOfBirth: json["date_of_birth"],
    gender: json["gender"],
    registrationDate: json["registration_date"] == null ? null : DateTime.parse(json["registration_date"]),
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    isActive: json["is_active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    phone: json["phone"],
    email: json["email"],
    profileImageCfMediaId: json["profile_image_cf_media_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "date_of_birth": dateOfBirth,
    "gender": gender,
    "registration_date": registrationDate?.toIso8601String(),
    "last_login": lastLogin?.toIso8601String(),
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "phone": phone,
    "email": email,
    "profile_image_cf_media_id": profileImageCfMediaId,
  };
}

class Rider {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final DateTime? dateOfBirth;
  final String? gender;
  final int? profileImageCfMediaId;
  final dynamic drivingLicenseNumber;
  final dynamic drivingLicenseAuthorizedOfficeId;
  final dynamic drivingLicenseCfMediaId;
  final dynamic verificationSelfieCfMediaId;
  final dynamic drivingCityId;
  final dynamic drivingDestinationRangeId;
  final dynamic drivingScheduleId;
  final int? isDrivingLicenseVerified;
  final int? isActive;
  final DateTime? registrationDate;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? isApproved;
  final int? activeVehicleId;

  Rider({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.profileImageCfMediaId,
    this.drivingLicenseNumber,
    this.drivingLicenseAuthorizedOfficeId,
    this.drivingLicenseCfMediaId,
    this.verificationSelfieCfMediaId,
    this.drivingCityId,
    this.drivingDestinationRangeId,
    this.drivingScheduleId,
    this.isDrivingLicenseVerified,
    this.isActive,
    this.registrationDate,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.isApproved,
    this.activeVehicleId,
  });

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
    id: json["id"],
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    gender: json["gender"],
    profileImageCfMediaId: json["profile_image_cf_media_id"],
    drivingLicenseNumber: json["driving_license_number"],
    drivingLicenseAuthorizedOfficeId: json["driving_license_authorized_office_id"],
    drivingLicenseCfMediaId: json["driving_license_cf_media_id"],
    verificationSelfieCfMediaId: json["verification_selfie_cf_media_id"],
    drivingCityId: json["driving_city_id"],
    drivingDestinationRangeId: json["driving_destination_range_id"],
    drivingScheduleId: json["driving_schedule_id"],
    isDrivingLicenseVerified: json["is_driving_license_verified"],
    isActive: json["is_active"],
    registrationDate: json["registration_date"] == null ? null : DateTime.parse(json["registration_date"]),
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isApproved: json["is_approved"],
    activeVehicleId: json["active_vehicle_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "email": email,
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "profile_image_cf_media_id": profileImageCfMediaId,
    "driving_license_number": drivingLicenseNumber,
    "driving_license_authorized_office_id": drivingLicenseAuthorizedOfficeId,
    "driving_license_cf_media_id": drivingLicenseCfMediaId,
    "verification_selfie_cf_media_id": verificationSelfieCfMediaId,
    "driving_city_id": drivingCityId,
    "driving_destination_range_id": drivingDestinationRangeId,
    "driving_schedule_id": drivingScheduleId,
    "is_driving_license_verified": isDrivingLicenseVerified,
    "is_active": isActive,
    "registration_date": registrationDate?.toIso8601String(),
    "last_login": lastLogin?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_approved": isApproved,
    "active_vehicle_id": activeVehicleId,
  };
}

class Warehouse {
  final int? id;
  final String? name;
  final String? abnNumber;
  final int? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Warehouse({
    this.id,
    this.name,
    this.abnNumber,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
    id: json["id"],
    name: json["name"],
    abnNumber: json["abn_number"],
    active: json["active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "abn_number": abnNumber,
    "active": active,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
