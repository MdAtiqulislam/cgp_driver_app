
import 'dart:async';
import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:cgp_driver_app/common_widgets/custom_snackbar.dart';
import 'package:cgp_driver_app/other_controllers/my_drawer_controller.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/notification_services.dart';
import 'package:cgp_driver_app/utils/enams.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/rider_model.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  var rider = RiderModel();
  var orderId = "".obs;
  var riderId = "".obs;
  StreamSubscription<Position>? positionStream;

  @override
  void onInit() async {
    super.onInit();
    connect();
  }

  void connect() {
    // Configure the Socket.io client
    socket = IO.io(APIEndPoints.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to the server
    socket.connect();

    // Handle connection event
    socket.on('connect', (_) async {
      if (kDebugMode) {
        print('Connected to the server');
      }
    });

    // Handle disconnection event
    socket.on('disconnect', (_) {
      if (kDebugMode) {
        print('Disconnected from the server');
      }
    });

    // Handle custom events from the server
    socket.on('locationUpdated', (data) {
      if (kDebugMode) {
        print('Location updated: $data');
      }
    });


    // Dynamically update listener for order status
    ever(orderId, (String id) {
      _registerOrderStatusListener(id);
    });

/*    // Dynamically update listener for order status
    ever(riderId, (String id) {
      _registerLoggedInStatusListener(id);
    });*/
  }

  void _registerOrderStatusListener(String id) {
    // Remove previous listener if any
    socket.off('orderStatusUpdated_$orderId');

    // Add new listener
    socket.on('orderStatusUpdated_$id', (data) {
      if (data != null) {
        if (kDebugMode) {
          print(data["shippingStatus"]);
        }

        if (data["shippingStatus"] == OrderStatus.cancelled.name||
            data["shippingStatus"] == "cancelled") {
          Get.put(OngoingTripController());
          Get.find<OngoingTripController>().cancelOrder(
              title: data["title"], message: data["message"]);
        }
      }
    });
  }

  void _registerLoggedInStatusListener(String id) {
    // Add new listener
    socket.on('riderNewLogin_$id', (data) async {
      if (data != null) {
       // NotificationServices().getDeviceToken().then((value) async {
        await FirebaseMessaging.instance.getToken().then((value) async {
          if(value!=data){
            await Get.put(MyDrawerController()).completeLogOut().then((value){
              Get.closeAllSnackbars();
              CustomSnackBar(
                  isSuccess: true,
                  duration: 5,
                  msg: "You have been logged out because your ID is active on another device."
              ).showSnackBar();
            });
          }

          if (kDebugMode) {
            print("FCM token: $value");
          }
        });
      }
    });
  }




  void sendLocation(int riderId, double latitude, double longitude) {
    socket.emit('updateLocation', {
   // socket.emit('riderLocationUpdated_$riderId', {
      'riderId': riderId,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  void sendDistanceAndDuration(
      {required String duration, required String distance}) {
    if (kDebugMode) {
      print("duration: $duration, distance: $distance");
    }
    socket.emit('updateOrderStatus', {
      'orderId': orderId.value,
      'distance': distance,
      'duration': duration,
    });
  }

  Future<void> getUser() async {
    await LocalServices.getUser().then((value) {
      if (value != null) {
        rider = value;
        riderId.value="${rider.id??""}";
        _registerLoggedInStatusListener(riderId.value);
      }
    });
  }

  void startLocationUpdates() async {
    await getUser().then((value) async {
      if (rider.isActive ?? false) {
        bool serviceEnabled;
        LocationPermission permissionGranted;

        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await Geolocator.openLocationSettings();
          if (!serviceEnabled) {
            return;
          }
        }

        permissionGranted = await Geolocator.checkPermission();
        if (permissionGranted == LocationPermission.denied) {
          permissionGranted = await Geolocator.requestPermission();
          if (permissionGranted != LocationPermission.whileInUse &&
              permissionGranted != LocationPermission.always) {
            return;
          }
        }

        positionStream?.cancel();
        positionStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 0, // Update every 10 meters
          ),
        ).listen((Position currentLocation) {
          if (rider.userId != null) {
            sendLocation(
                rider.id ?? 0, currentLocation.latitude, currentLocation.longitude);
            final locationMessage = {
              'event': 'updateLocation',
              'data': {
                'riderId': rider.id,
                'latitude': currentLocation.latitude,
                'longitude': currentLocation.longitude,
              }
            };
            // channel.sink.add(locationMessage.toString());
            if (kDebugMode) {
              print(locationMessage);
            }
          }
        });
      }
    });
  }

  void _stopLocationUpdates() {
    positionStream?.cancel();
  }

  void disconnect() {
    if (kDebugMode) {
      print("Disconnecting.....");
    }
    _stopLocationUpdates();
    socket.disconnect();
  }

  // Call this method to update the orderId and re-register the listener
  void updateOrderId(String newOrderId) {
    orderId.value = newOrderId;
  }
}
