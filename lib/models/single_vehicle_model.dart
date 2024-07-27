
import 'package:cgp_driver_app/models/single_vehicle_type_model.dart';

class SingleVehicleModel {
  final int? id;
  final dynamic ownerId;
  final String? brand;
  final String? model;
  final String? color;
  final int? vehicleImageCfMediaId;
  final String? licensePlate;
  final dynamic year;
  final String? registrationNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SingleVehicleTypeModel? type;
  final String? vehicleBackImageUrl;
  final String? vehicleFrontImageUrl;

  SingleVehicleModel({
    this.id,
    this.ownerId,
    this.brand,
    this.model,
    this.color,
    this.vehicleImageCfMediaId,
    this.licensePlate,
    this.year,
    this.registrationNumber,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.vehicleBackImageUrl,
    this.vehicleFrontImageUrl,
  });

  factory SingleVehicleModel.fromJson(Map<String, dynamic> json) => SingleVehicleModel(
    id: json["id"],
    ownerId: json["owner_id"],
    brand: json["brand"],
    model: json["model"],
    color: json["color"],
    year: json["year"],
    vehicleImageCfMediaId: json["vehicle_image_cf_media_id"],
    licensePlate: json["license_plate"],
    registrationNumber: json["registration_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    type: json["type"] == null ? null : SingleVehicleTypeModel.fromJson(json["type"]),
    vehicleFrontImageUrl: json["vehicle_front_image_url"],
    vehicleBackImageUrl: json["vehicle_back_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_id": ownerId,
    "brand": brand,
    "model": model,
    "color": color,
    "year": year,
    "vehicle_image_cf_media_id": vehicleImageCfMediaId,
    "license_plate": licensePlate,
    "registration_number": registrationNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "type": type?.toJson(),
    "vehicle_front_image_url": vehicleFrontImageUrl,
    "vehicle_back_image_url": vehicleBackImageUrl,
  };
}