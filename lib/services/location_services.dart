

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationServices{

 static late LocationSettings locationSettings;
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
    //print(positionStream.toString());
    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getAddress(LatLng value) async {
    List<Placemark> placeMarks =
    await placemarkFromCoordinates(value.latitude, value.longitude);

    String address = "${placeMarks.first.street},"
        "${placeMarks.first.subLocality},"
        "${placeMarks.first.locality},"
        "${placeMarks.first.country} ";

    return address;
  }

  static Future<String> getAddressFromMap(LatLng value) async {
   List<Placemark> placeMarks =
   await placemarkFromCoordinates(value.latitude, value.longitude);
   return "${placeMarks.first.street},"
       "${placeMarks.first.subLocality},"
       "${placeMarks.first.locality},"
       "${placeMarks.first.country} ";
 }

  static Future<List<Placemark>> getPlaceMarksFromLatLng({required String lat, required String lng}) async {
   List<Placemark> placeMarks =
   await placemarkFromCoordinates(double.parse(lat), double.parse(lng));
   return placeMarks;
 }
}