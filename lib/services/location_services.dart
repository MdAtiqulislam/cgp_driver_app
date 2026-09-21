
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServices {
  static late LocationSettings locationSettings;

  /// Returns current location after proper permission checks
  static Future<Position> getCurrentLocation() async {
    // Step 1: Ensure location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Step 2: Foreground location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, cannot request permissions.');
    }

    // Step 3: Background location permission only if user gave consent
    if (Platform.isAndroid || Platform.isIOS) {
      PermissionStatus backgroundStatus = await Permission.locationAlways.status;
      if (!backgroundStatus.isGranted) {
        // You can show a Prominent Disclosure dialog here before requesting
        backgroundStatus = await Permission.locationAlways.request();
        if (!backgroundStatus.isGranted) {
          // Continue with foreground location only
          // Optional: Log or notify user that background tracking is limited
        }
      }
    }

    // Step 4: Platform-specific settings
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
          "The app will continue to receive your location in the background.",
          notificationTitle: "Location Updates Enabled",
          enableWakeLock: true,
        ),
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    // Step 5: Get current location
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return Future.error("Failed to get location: $e");
    }
  }

  /// Get address from LatLng
  static Future<String> getAddress(LatLng value) async {
    try {
      List<Placemark> placeMarks =
      await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark place = placeMarks.first;
      return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
    } catch (e) {
      return "Failed to get address: $e";
    }
  }

  static Future<String> getAddressFromMap(LatLng value) async {
    return getAddress(value); // reuse
  }

  static Future<List<Placemark>> getPlaceMarksFromLatLng({
    required String lat,
    required String lng,
  }) async {
    try {
      return await placemarkFromCoordinates(double.parse(lat), double.parse(lng));
    } catch (e) {
      throw Exception("Failed to get place marks: $e");
    }
  }
}



/*
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../app/routes/app_pages.dart';


class LocationServices {
  static late LocationSettings locationSettings;

  /// Get current location; navigate to splash only if not already there
  static Future<Position?> getCurrentLocation({bool navigateToSplash = true}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (navigateToSplash && Get.currentRoute != Routes.ONBORDING) {
        Get.toNamed(Routes.ONBORDING);
      }
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (navigateToSplash && Get.currentRoute != Routes.ONBORDING) {
        Get.toNamed(Routes.ONBORDING);
      }
      return null;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      PermissionStatus backgroundStatus = await Permission.locationAlways.status;
      if (!backgroundStatus.isGranted) {
        if (navigateToSplash && Get.currentRoute != Routes.ONBORDING) {
          Get.toNamed(Routes.ONBORDING);
        }
        return null;
      }
    }

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
        intervalDuration: const Duration(seconds: 10),
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 50,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
      );
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      if (navigateToSplash && Get.currentRoute != Routes.ONBORDING) {
        Get.toNamed(Routes.ONBORDING);
      }
      return null;
    }
  }

  /// Get address from LatLng
  static Future<String> getAddress(LatLng value) async {
    try {
      List<Placemark> placeMarks =
      await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark place = placeMarks.first;
      return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
    } catch (e) {
      return "Failed to get address: $e";
    }
  }
}*/
