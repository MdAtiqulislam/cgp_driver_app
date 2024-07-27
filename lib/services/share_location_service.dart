/*import 'dart:io';

import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

//import 'package:google_places_flutter/model/place_details.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ShareLocationService extends GetxService {
  late WebSocketChannel channel;

  final String url ;
 // final channel = WebSocketChannel.connect(Uri.parse('wss://cgp-rider-api.onrender.com'));

  var rider = RiderModel();
  Location location = Location();
  late Position currentLocation;

  ShareLocationService({required this.url}){
    try {
      channel = WebSocketChannel.connect(Uri.parse(url));
     // _listenToWebSocket();
    } catch (e ) {
      // Handle the exception here
      print('WebSocketChannelException_Find: ${e}');
      // Log the exception details
      if (e is WebSocketChannelException) {
        print('WebSocketChannelException: ${e.message}');
      } else if (e is WebSocketException) {
        print('WebSocketException: ${e.message}');
        // Check for more specific details if available
        print('Details: ${e.toString()}');
      } else if (e is SocketException) {
        // Handle network-related exceptions
        print('SocketException: ${e.message}');
        print('OS Error: ${e.osError?.message}');
      } else {
        print('Other Exception: $e');
      }

    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getUser();
    _startLocationUpdates();
  }

  void _startLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {

      if (rider.userId != null) {
        final locationMessage = {
          'event':'updateLocation',
          'data':{'riderId':rider.id,
            'latitude': currentLocation.latitude,
            'longitude': currentLocation.longitude,}
        };
       // channel.sink.add(locationMessage.toString());
        print(locationMessage);
      }
     // print("Location Data:${currentLocation.longitude}");
    });
  }

  *//* Future<void> sendMyLocation() async {

    RiderModel riderModel=await LocalServices.getUser()??RiderModel();


   if(riderModel.userId!=null){
      location = await _getCurrentLocation();
     final locationMessage = {
       'riderId':riderModel.userId,
       'latitude': currentLocation.latitude,
       'longitude': currentLocation.longitude,
     };
     channel.sink.add(locationMessage.toString());
   }



    }

  Future<LocationData> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }
*//*

  void _listenToWebSocket() {
    *//*try {
      channel.stream.listen(
            (message) {
          // Handle incoming messages
          print('Received: $message');
        },
        onError: (error) {
          // Handle errors
          print('Error: $error');
        },
        onDone: () {
          // Handle WebSocket closure
          print('Connection closed');
        },
      );
    } on Exception catch (e) {
      print("Problem: ------${e.toString()}");
    }*//*
  }



  void closeConnection() {
  //  channel.sink.close();
  }

  Future<void> getUser() async {
    await LocalServices.getUser().then((value) {
      if (value != null) {
        rider = value;
      }
    });
  }
}*/
