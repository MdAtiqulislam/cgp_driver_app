class MessageDataModel {
  final int? id;
  final dynamic warehouseId;
  final dynamic orderId;
  final dynamic senderId;
  final dynamic receiverId;
  final dynamic replyById;
  final dynamic replyToId;
  final dynamic replyByTypeId;
  final dynamic replyToTypeId;
  final String? message;
  final int? readAt;
  final int? cfMediaStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageDataModel({
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
  });

  factory MessageDataModel.fromJson(Map<String, dynamic> json) => MessageDataModel(
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
  };
}