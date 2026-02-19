// To parse this JSON data, do
//
//     final loadMessageModel = loadMessageModelFromJson(jsonString);

import 'dart:convert';

import 'package:cgp_driver_app/models/message_data_model.dart';

LoadMessageModel loadMessageModelFromJson(String str) => LoadMessageModel.fromJson(json.decode(str));

String loadMessageModelToJson(LoadMessageModel data) => json.encode(data.toJson());

class LoadMessageModel {
  final String? message;
  final String? status;
  final List<MessageDataModel>? data;

  LoadMessageModel({
    this.message,
    this.status,
    this.data,
  });

  factory LoadMessageModel.fromJson(Map<String, dynamic> json) => LoadMessageModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? [] : List<MessageDataModel>.from(json["data"]!.map((x) => MessageDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

/*class Datum {
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
  final String? reqularImages;
  final String? reqularFiles;
  final Customer? customer;
  final Rider? rider;
  final Warehouse? warehouse;

  Datum({
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
    this.reqularImages,
    this.reqularFiles,
    this.customer,
    this.rider,
    this.warehouse,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    reqularImages: json["reqular_images"],
    reqularFiles: json["reqular_files"],
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
    "reqular_images": reqularImages,
    "reqular_files": reqularFiles,
    "customer": customer?.toJson(),
    "rider": rider?.toJson(),
    "warehouse": warehouse?.toJson(),
  };
}

class Customer {
  final int? id;
  final int? userId;
  final StName? firstName;
  final LastName? lastName;
  final dynamic dateOfBirth;
  final dynamic gender;
  final DateTime? registrationDate;
  final DateTime? lastLogin;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? phone;
  final CustomerEmail? email;
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
    firstName: stNameValues.map[json["first_name"]]!,
    lastName: lastNameValues.map[json["last_name"]]!,
    dateOfBirth: json["date_of_birth"],
    gender: json["gender"],
    registrationDate: json["registration_date"] == null ? null : DateTime.parse(json["registration_date"]),
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    isActive: json["is_active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    phone: json["phone"],
    email: customerEmailValues.map[json["email"]]!,
    profileImageCfMediaId: json["profile_image_cf_media_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "first_name": stNameValues.reverse[firstName],
    "last_name": lastNameValues.reverse[lastName],
    "date_of_birth": dateOfBirth,
    "gender": gender,
    "registration_date": registrationDate?.toIso8601String(),
    "last_login": lastLogin?.toIso8601String(),
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "phone": phone,
    "email": customerEmailValues.reverse[email],
    "profile_image_cf_media_id": profileImageCfMediaId,
  };
}

enum CustomerEmail {
  ATIQUL58_GMAIL_COM,
  MEHADI_REVINR_COM
}

final customerEmailValues = EnumValues({
  "atiqul58@gmail.com": CustomerEmail.ATIQUL58_GMAIL_COM,
  "mehadi@revinr.com": CustomerEmail.MEHADI_REVINR_COM
});

enum StName {
  ATIQUL,
  MD
}

final stNameValues = EnumValues({
  "Atiqul": StName.ATIQUL,
  "Md": StName.MD
});

enum LastName {
  ISLAM,
  MEHADI
}

final lastNameValues = EnumValues({
  "Islam": LastName.ISLAM,
  "Mehadi": LastName.MEHADI
});

class Rider {
  final int? id;
  final int? userId;
  final StName? firstName;
  final StName? lastName;
  final String? phone;
  final RiderEmail? email;
  final DateTime? dateOfBirth;
  final Gender? gender;
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
    firstName: stNameValues.map[json["first_name"]]!,
    lastName: stNameValues.map[json["last_name"]]!,
    phone: json["phone"],
    email: riderEmailValues.map[json["email"]]!,
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    gender: genderValues.map[json["gender"]]!,
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
    "first_name": stNameValues.reverse[firstName],
    "last_name": stNameValues.reverse[lastName],
    "phone": phone,
    "email": riderEmailValues.reverse[email],
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "gender": genderValues.reverse[gender],
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

enum RiderEmail {
  ATIQULISLAM_DEV_GMAIL_COM
}

final riderEmailValues = EnumValues({
  "atiqulislam.dev@gmail.com": RiderEmail.ATIQULISLAM_DEV_GMAIL_COM
});

enum Gender {
  FEMALE
}

final genderValues = EnumValues({
  "female": Gender.FEMALE
});

class Warehouse {
  final int? id;
  final Name? name;
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
    name: nameValues.map[json["name"]]!,
    abnNumber: json["abn_number"],
    active: json["active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "abn_number": abnNumber,
    "active": active,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

enum Name {
  DEMO_TEST_PURPOSE,
  THE_64_A_ORFANEJ_ROAD_LALBAGH_DHAKA
}

final nameValues = EnumValues({
  "Demo Test Purpose": Name.DEMO_TEST_PURPOSE,
  "6/4 A, Orfanej Road Lalbagh, Dhaka.": Name.THE_64_A_ORFANEJ_ROAD_LALBAGH_DHAKA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}*/
