class OngoingTripShortModel {
  final int? orderId;
  final int? deliveryId;
  final String? shippingStatus;
  final dynamic deliveryRequestId;

  OngoingTripShortModel({
    this.orderId,
    this.deliveryId,
    this.shippingStatus,
    this.deliveryRequestId,
  });

  factory OngoingTripShortModel.fromJson(Map<String, dynamic> json) => OngoingTripShortModel(
    orderId: json["order_id"],
    deliveryId: json["delivery_id"],
    shippingStatus: json["shipping_status"],
    deliveryRequestId: json["delivery_request_id"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "delivery_id": deliveryId,
    "shipping_status": shippingStatus,
    "delivery_request_id": deliveryRequestId,
  };
}
