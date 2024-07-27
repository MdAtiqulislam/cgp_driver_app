enum AddressType { billing, pickup, shipping }

extension AddressTypwExtension on AddressType {
  String get name {
    switch (this) {
      case AddressType.billing:
        return 'billing';
      case AddressType.pickup:
        return 'pickup';
      case AddressType.shipping:
        return 'shipping';
    }
  }
}enum

ImageType { profile, vehicleFront, vehicleBack }

extension ImageTypeExtension on ImageType {
  String get name {
    switch (this) {
      case ImageType.profile:
        return "profileImage";
      case ImageType.vehicleFront:
        return "frontImage";
      case ImageType.vehicleBack:
        return "backImage";
    }
  }
}

enum OrderType {
  productAndTransport,
  transportationOnly,
}

extension OrderTypeExtension on OrderType {
  String get name {
    switch (this) {
      case OrderType.productAndTransport:
        return 'product_and_transport';
      case OrderType.transportationOnly:
        return 'transportation_only';
    }
  }
}

enum OrderStatus {
  pending,
  waiting,
  waitingAtPickupPoint,
  waitingAtDestinationPoint,
  searching,
  accepted,
  reachedAtPickupPoint,
  pickedUp,
  reachedAtDeliveryPoint,
  delivered,
  expired,
  cancelled, completed,

}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.waiting:
        return 'waiting';
      case OrderStatus.searching:
        return 'searching';
      case OrderStatus.accepted:
        return "accepted";
      case OrderStatus.reachedAtPickupPoint:
        return "reached_at_pickup_point";
      case OrderStatus.pickedUp:
        return "picked_up";
      case OrderStatus.reachedAtDeliveryPoint:
        return "reached_at_delivery_point";
      case OrderStatus.delivered:
        return "delivered";
      case OrderStatus.expired:
        return "expired";
      case OrderStatus.cancelled:
        return "cancelled";
      case OrderStatus.pending:
        return "pending";
      case OrderStatus.waitingAtPickupPoint:
        return "waiting_at_pickup_point";
      case OrderStatus.waitingAtDestinationPoint:
        return "waiting_at_destination_point";
      case OrderStatus.completed:
        return "completed";
    }
  }
}
