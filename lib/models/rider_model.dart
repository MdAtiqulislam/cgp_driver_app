
import 'package:cgp_driver_app/other_controllers/avg_ratings_model.dart';

import 'on_going_trip_short_model.dart';

class RiderModel {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final dynamic dateOfBirth;
  final dynamic gender;
  final dynamic profileImageCfMediaId;
  final dynamic drivingLicenseNumber;
  final dynamic drivingLicenseAuthorizedOfficeId;
  final dynamic drivingLicenseCfMediaId;
  final dynamic verificationSelfieCfMediaId;
  final dynamic drivingCityId;
  final dynamic drivingDestinationRangeId;
  final dynamic drivingScheduleId;
  final bool? isDrivingLicenseVerified;
  final bool? isActive;
  final bool? isApproved;
  final DateTime? registrationDate;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic profileImageUrl;
  final AvgRating? avgRating;
  final OngoingTripShortModel? ongoingTrip;
  final String? activeDeviceToken;

  RiderModel({
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
    this.isApproved,
    this.registrationDate,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
    this.avgRating,
    this.ongoingTrip,
    this.activeDeviceToken,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) => RiderModel(
    id: json["id"],
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    dateOfBirth: json["date_of_birth"],
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
    isApproved: json["is_approved"],
    activeDeviceToken: json["active_device_token"],
    registrationDate: json["registration_date"] == null ? null : DateTime.parse(json["registration_date"]),
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    profileImageUrl: json["profile_image_url"],
    avgRating: json["avg_rating"] == null ? null : AvgRating.fromJson(json["avg_rating"]),
    ongoingTrip: json["ongoing_trip"] == null ? null : OngoingTripShortModel.fromJson(json["ongoing_trip"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "email": email,
    "date_of_birth": dateOfBirth,
    "gender": gender,
    "active_device_token": activeDeviceToken,
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
    "is_approved": isApproved,
    "registration_date": registrationDate?.toIso8601String(),
    "last_login": lastLogin?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "profile_image_url": profileImageUrl,
    "avg_rating": avgRating?.toJson(),
    "ongoing_trip": ongoingTrip?.toJson(),
  };
}
