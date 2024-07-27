
import 'dart:async';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/rider_model.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  var rider = RiderModel();
  StreamSubscription<Position>? positionStream;

  @override
  void onInit() async {
    super.onInit();
    connect();
  }

  void connect() {
    // Configure the Socket.io client
    socket = IO.io('https://cgp-rider-api.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to the server
    socket.connect();

    // Handle connection event
    socket.on('connect', (_) async {
      print('Connected to the server');
       });

    // Handle disconnection event
    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });

    // Handle custom events from the server
    socket.on('locationUpdated', (data) {
      print('Location updated: $data');
    });
  }

  void sendLocation(int riderId, double latitude, double longitude) {
    socket.emit('updateLocation', {
      'riderId': riderId,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<void> getUser() async {
    await LocalServices.getUser().then((value) {
      if (value != null) {
        rider = value;
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
        positionStream =  Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 0, // Update every 10 meters
          ),
        ).listen((Position currentLocation) {
          if (rider.userId != null) {
            sendLocation(
              rider.id ?? 0,
              currentLocation.latitude,
              currentLocation.longitude
            );
            final locationMessage = {
              'event': 'updateLocation',
              'data': {
                'riderId': rider.id,
                'latitude': currentLocation.latitude,
                'longitude': currentLocation.longitude,
              }
            };
            // channel.sink.add(locationMessage.toString());
            print(locationMessage);
          }
        });
      }
    });
  }




  void _stopLocationUpdates() {
    positionStream?.cancel();
  }

  void disconnect() {
    print("Disconnecting.....");
    _stopLocationUpdates();
    socket.disconnect();
  }
}
