class SingleVehicleTypeModel {
  final String? id;
  final int? typeId;
  final String? name;
  final String? code;
  final String? mediaUrl;
  final String? vehicleCapacity;
  final int? active;

  SingleVehicleTypeModel({
    this.id,
    this.typeId,
    this.name,
    this.code,
    this.mediaUrl,
    this.vehicleCapacity,
    this.active,
  });

  factory SingleVehicleTypeModel.fromJson(Map<String, dynamic> json) => SingleVehicleTypeModel(
    id: json["id"],
    typeId: json["type_id"],
    name: json["name"],
    code: json["code"],
    mediaUrl: json["media_url"],
    vehicleCapacity: json["vehicle_capacity"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type_id": typeId,
    "name": name,
    "code": code,
    "media_url": mediaUrl,
    "vehicle_capacity": vehicleCapacity,
    "active": active,
  };
}