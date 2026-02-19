class BankInfoModel {
  final int? id;
  final dynamic customerId;
  final dynamic warehouseId;
  final dynamic verifiedAt;
  final int? riderId;
  final String? bankName;
  final String? accountNumber;
  final String? accountHolderName;
  final String? bsb;
  final bool? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BankInfoModel({
    this.id,
    this.customerId,
    this.warehouseId,
    this.riderId,
    this.bankName,
    this.accountNumber,
    this.accountHolderName,
    this.bsb,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.verifiedAt
  });

  factory BankInfoModel.fromJson(Map<String, dynamic> json) => BankInfoModel(
    id: json["id"],
    customerId: json["customer_id"],
    warehouseId: json["warehouse_id"],
    riderId: json["rider_id"],
    bankName: json["bank_name"],
    verifiedAt: json["verified_at"],
    accountNumber: json["account_number"],
    accountHolderName: json["account_holder_name"],
    bsb: json["bsb"],
    isDefault: json["is_default"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "warehouse_id": warehouseId,
    "rider_id": riderId,
    "bank_name": bankName,
    "verified_at": verifiedAt,
    "account_number": accountNumber,
    "account_holder_name": accountHolderName,
    "bsb": bsb,
    "is_default": isDefault,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}