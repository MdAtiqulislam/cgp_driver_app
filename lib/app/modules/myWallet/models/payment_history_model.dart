// To parse this JSON data, do
//
//     final paymentHistoryModel = paymentHistoryModelFromJson(jsonString);

import 'dart:convert';

PaymentHistoryModel paymentHistoryModelFromJson(String str) => PaymentHistoryModel.fromJson(json.decode(str));

String paymentHistoryModelToJson(PaymentHistoryModel data) => json.encode(data.toJson());

class PaymentHistoryModel {
  final String? message;
  final String? status;
  final PaymentHistoryData? data;

  PaymentHistoryModel({
    this.message,
    this.status,
    this.data,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) => PaymentHistoryModel(
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? null : PaymentHistoryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data?.toJson(),
  };
}

class PaymentHistoryData {
  final dynamic currentBalance;
  final dynamic lastSettlementAmount;
  final bool? withdrawRequest;
  final List<SinglePaymentModel>? paymentHistory;

  PaymentHistoryData({
    this.currentBalance,
    this.lastSettlementAmount,
    this.paymentHistory,
    this.withdrawRequest,
  });

  factory PaymentHistoryData.fromJson(Map<String, dynamic> json) => PaymentHistoryData(
    currentBalance: json["current_balance"],
    lastSettlementAmount: json["last_settlement_amount"],
    withdrawRequest: json["withdraw_request"],
    paymentHistory: json["payment_history"] == null ? [] : List<SinglePaymentModel>.from(json["payment_history"]!.map((x) => SinglePaymentModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "current_balance": currentBalance,
    "last_settlement_amount": lastSettlementAmount,
    "withdraw_request": withdrawRequest,
    "payment_history": paymentHistory == null ? [] : List<dynamic>.from(paymentHistory!.map((x) => x.toJson())),
  };
}

class SinglePaymentModel {
  final int? id;
  final String? transactionType;
  final String? paymentStatus;
  final String? paymentBy;
  final String? paymentFor;
  final int? paymentId;
  final int? customerId;
  final dynamic warehouseId;
  final int? riderId;
  final int? orderId;
  final String? fareAmount;
  final String? gst;
  final String? tradebarFee;
  final dynamic netBalance;
  final dynamic payableAmount;
  final dynamic settlementAmount;
  final dynamic refundAmount;
  final dynamic remarks;
  final dynamic cfMediaId;
  final DateTime? createdAt;
  final dynamic partialPaidAt;
  final DateTime? paidAt;
  final dynamic failedAt;
  final dynamic partialRefundedAt;
  final dynamic refundedAt;
  final dynamic settlementAt;
  final DateTime? updatedAt;

  SinglePaymentModel({
    this.id,
    this.transactionType,
    this.paymentStatus,
    this.paymentBy,
    this.paymentFor,
    this.paymentId,
    this.customerId,
    this.warehouseId,
    this.riderId,
    this.orderId,
    this.fareAmount,
    this.gst,
    this.tradebarFee,
    this.netBalance,
    this.payableAmount,
    this.settlementAmount,
    this.refundAmount,
    this.remarks,
    this.cfMediaId,
    this.createdAt,
    this.partialPaidAt,
    this.paidAt,
    this.failedAt,
    this.partialRefundedAt,
    this.refundedAt,
    this.settlementAt,
    this.updatedAt,
  });

  factory SinglePaymentModel.fromJson(Map<String, dynamic> json) => SinglePaymentModel(
    id: json["id"],
    transactionType: json["transaction_type"],
    paymentStatus: json["payment_status"],
    paymentBy: json["payment_by"],
    paymentFor: json["payment_for"],
    paymentId: json["payment_id"],
    customerId: json["customer_id"],
    warehouseId: json["warehouse_id"],
    riderId: json["rider_id"],
    orderId: json["order_id"],
    fareAmount: json["fare_amount"],
    gst: json["gst"],
    tradebarFee: json["tradebar_fee"],
    netBalance: json["net_balance"],
    payableAmount: json["payable_amount"],
    settlementAmount: json["settlement_amount"],
    refundAmount: json["refund_amount"],
    remarks: json["remarks"],
    cfMediaId: json["cf_media_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    partialPaidAt: json["partial_paid_at"],
    paidAt: json["paid_at"] == null ? null : DateTime.parse(json["paid_at"]),
    failedAt: json["failed_at"],
    partialRefundedAt: json["partial_refunded_at"],
    refundedAt: json["refunded_at"],
    settlementAt: json["settlement_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_type": transactionType,
    "payment_status": paymentStatus,
    "payment_by": paymentBy,
    "payment_for": paymentFor,
    "payment_id": paymentId,
    "customer_id": customerId,
    "warehouse_id": warehouseId,
    "rider_id": riderId,
    "order_id": orderId,
    "fare_amount": fareAmount,
    "gst": gst,
    "tradebar_fee": tradebarFee,
    "net_balance": netBalance,
    "payable_amount": payableAmount,
    "settlement_amount": settlementAmount,
    "refund_amount": refundAmount,
    "remarks": remarks,
    "cf_media_id": cfMediaId,
    "created_at": createdAt?.toIso8601String(),
    "partial_paid_at": partialPaidAt,
    "paid_at": paidAt?.toIso8601String(),
    "failed_at": failedAt,
    "partial_refunded_at": partialRefundedAt,
    "refunded_at": refundedAt,
    "settlement_at": settlementAt,
    "updated_at": updatedAt?.toIso8601String(),
  };
}
