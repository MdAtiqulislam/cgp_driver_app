/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:location/location.dart';

import '../../../routes/app_pages.dart';

class CustomNavigationController extends GetxController {
  late MapBoxNavigation _directions;
  late MapBoxOptions options;
  var isNavigating = false.obs;
  var routeProgress = "".obs;
  var currentLocation = LocationData.fromMap({"latitude": 0.0, "longitude": 0.0}).obs;
  var isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _directions = MapBoxNavigation();
    _initializeLocation();

    // Subscribe to events
    _directions.registerRouteEventListener(onRouteEvent);
  }

  void _initializeLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Location services not enabled");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Location permission denied");
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocationData) {
      currentLocation.value = currentLocationData;
      if (!isInitialized.value) {
        isInitialized.value = true;
        print("Current location updated: ${currentLocation.value.latitude}, ${currentLocation.value.longitude}");
      }
    });

    LocationData locationData = await location.getLocation();
    currentLocation.value = locationData;
    isInitialized.value = true;
    print("Initial location: ${currentLocation.value.latitude}, ${currentLocation.value.longitude}");
  }



  void startNavigation(double destinationLat, double destinationLng) async {
    if (!isInitialized.value) {
      print("Location not initialized yet. Retrying in 1 second...");
      Future.delayed(Duration(seconds: 1), () {
        startNavigation(destinationLat, destinationLng);
      });
      return;
    }

    var wayPoints = <WayPoint>[
      WayPoint(name: "Start", latitude: currentLocation.value.latitude!, longitude: currentLocation.value.longitude!),
      WayPoint(name: "End", latitude: destinationLat, longitude: destinationLng),
    ];

    print("wayPoints.first.longitude: ${wayPoints.first.longitude}");
    print(wayPoints.last.longitude);

    options = MapBoxOptions(
      initialLatitude: currentLocation.value.latitude!,
      initialLongitude: currentLocation.value.longitude!,
      zoom: 14.0,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      simulateRoute: false,
      enableRefresh: true,
      showEndOfRouteFeedback: false,
      showReportFeedbackButton: false,
      language: "en",
    );

    isNavigating.value = true;
    _directions.enableOfflineRouting();
    _directions.setDefaultOptions(options);
    await _directions.startNavigation(wayPoints: wayPoints, options: options);
    print("Navigation started");
  }

  void stopNavigation() async {
    await _directions.finishNavigation();

    isNavigating.value = false;
    print("Navigation stopped");
  }

  Future<void> onRouteEvent(e) async {
    routeProgress.value = e.eventType.toString();
    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          routeProgress.value = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        isNavigating.value = true;
        break;
      case MapBoxEvent.route_build_failed:
        isNavigating.value = false;
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        isNavigating.value = false;
        Get.offAndToNamed(Routes.ONGOING_TRIP);
        break;
      default:
        break;
    }
    print("Route event: ${e.eventType}");
  }
}
*/

/*

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:location/location.dart';

import '../../../routes/app_pages.dart';

class CustomNavigationController extends GetxController {
  late MapBoxNavigation _directions;
  late MapBoxOptions options;
  var isNavigating = false.obs;
  var routeProgress = "".obs;
  var currentLocation = LocationData.fromMap({"latitude": 0.0, "longitude": 0.0}).obs;
  var isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _directions = MapBoxNavigation();
    _initializeLocation();

    // Subscribe to events
    _directions.registerRouteEventListener(onRouteEvent);
  }

  void _initializeLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Location services not enabled");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Location permission denied");
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocationData) {
      currentLocation.value = currentLocationData;
      if (!isInitialized.value) {
        isInitialized.value = true;
        print("Current location updated: ${currentLocation.value.latitude}, ${currentLocation.value.longitude}");
      }
    });

    LocationData locationData = await location.getLocation();
    currentLocation.value = locationData;
    isInitialized.value = true;
    print("Initial location: ${currentLocation.value.latitude}, ${currentLocation.value.longitude}");
  }

  Future<void> startNavigation(double destinationLat, double destinationLng) async {
    if (!isInitialized.value) {
      print("Location not initialized yet. Retrying in 1 second...");
      Future.delayed(const Duration(seconds: 0), () {
        startNavigation(destinationLat, destinationLng);
      });
      return;
    }

    var wayPoints = <WayPoint>[
      WayPoint(name: "Start", latitude: currentLocation.value.latitude!, longitude: currentLocation.value.longitude!),
      WayPoint(name: "End", latitude: destinationLat, longitude: destinationLng),
    ];

    print("wayPoints.first.longitude: ${wayPoints.first.longitude}");
    print(wayPoints.last.longitude);

    options = MapBoxOptions(
      initialLatitude: currentLocation.value.latitude!,
      initialLongitude: currentLocation.value.longitude!,
      zoom: 14.0,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      simulateRoute: false,
      enableRefresh: true,
      showEndOfRouteFeedback: false,
      showReportFeedbackButton: false,
      language: "en",
    );

    isNavigating.value = true;
    _directions.enableOfflineRouting();
    _directions.setDefaultOptions(options);
    await _directions.startNavigation(wayPoints: wayPoints, options: options);
    print("Navigation started");
  }

  void stopNavigation() async {
    await _directions.finishNavigation();

    isNavigating.value = false;
    print("Navigation stopped");
  }

  Future<void> onRouteEvent(e) async {
    routeProgress.value = e.eventType.toString();
    print("routeProgress: $routeProgress");
    switch (e.eventType) {

      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
      //  _arrived = progressEvent.arrived;

        if((progressEvent.currentLegDistanceRemaining??50)<=20){
          _directions.finishNavigation();
          stopNavigation();
          Get.offAndToNamed(Routes.ONGOING_TRIP);
        }
     print("progressEvent.arrived:${progressEvent.arrived}");

        if (progressEvent.currentStepInstruction != null) {
          //  _instruction = progressEvent.currentStepInstruction;
        print("progressEvent.currentStepInstruction:${progressEvent.currentLegDistanceRemaining}");
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        isNavigating.value = true;
        break;
      case MapBoxEvent.route_build_failed:
        isNavigating.value = false;
        break;
      case MapBoxEvent.navigation_finished:
        print(">>>>>>>>>>>>>>>>>>>");
        break;
      case MapBoxEvent.navigation_cancelled:
        isNavigating.value = false;
        Get.offAndToNamed(Routes.ONGOING_TRIP);
        break;
      default:
        break;
    }
    print("Route event: ${e.eventType}");
  }
}


 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../utils/utils.dart';
import '../../../routes/app_pages.dart';

class CustomNavigationController extends GetxController {
  late MapBoxNavigation _directions;
  late MapBoxOptions options;
  var isNavigating = false.obs;
  var routeProgress = "".obs;
  var currentLocation =
      LocationData.fromMap({"latitude": 0.0, "longitude": 0.0}).obs;
  var isInitialized = false.obs;

  var destination = LatLng(0.0, 0.0).obs;

  @override
  void onInit() {
    super.onInit();
    options = MapBoxOptions(
      initialLatitude: currentLocation.value.latitude!,
      initialLongitude: currentLocation.value.longitude!,
      zoom: 14.0,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      simulateRoute: false,
      enableRefresh: true,
      showEndOfRouteFeedback: false,
      showReportFeedbackButton: false,
      language: "en",
    );
    _directions = MapBoxNavigation();
    _initializeLocation();

    // Subscribe to events
    _directions.registerRouteEventListener(onRouteEvent);
  }

  void _initializeLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocationData) {
      currentLocation.value = currentLocationData;
      if (!isInitialized.value) {
        isInitialized.value = true;
      }
    });

    LocationData locationData = await location.getLocation();
    currentLocation.value = locationData;
    isInitialized.value = true;
  }

  Future<void> startNavigation(
      double destinationLat, double destinationLng) async {
    destination.value = LatLng(destinationLat, destinationLng);

    if (!isInitialized.value) {
      Future.delayed(const Duration(seconds: 1), () {
        startNavigation(destinationLat, destinationLng);
      });
      return;
    }

    var wayPoints = <WayPoint>[
      WayPoint(
          name: "Start",
          latitude: currentLocation.value.latitude!,
          longitude: currentLocation.value.longitude!),
      WayPoint(
          name: "End", latitude: destinationLat, longitude: destinationLng),
    ];

/*    options = MapBoxOptions(
      initialLatitude: currentLocation.value.latitude!,
      initialLongitude: currentLocation.value.longitude!,
      zoom: 14.0,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      simulateRoute: true,
      enableRefresh: true,
      showEndOfRouteFeedback: false,
      showReportFeedbackButton: false,
      language: "en",
    );*/

    isNavigating.value = true;

    try {
      await _directions.enableOfflineRouting();
    } catch (e) {
      if (e is PlatformException && e.code == 'TODO') {
        // Optionally handle this case, e.g., show a message to the user
      } else {
        rethrow;
      }
    }

    _directions.setDefaultOptions(options);
    await _directions.startNavigation(wayPoints: wayPoints, options: options);
  }

  void stopNavigation() async {
    await _directions.finishNavigation();

    isNavigating.value = false;
  }

  Future<void> onRouteEvent(e) async {
    routeProgress.value = e.eventType.toString();
    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;

        var distanceInMeter = await calculateDistanceInMeter(destination.value);

        print("distanceInMeter: ${await _directions.getDistanceRemaining()}");

        if (distanceInMeter <= 100 ||
            (await _directions.getDistanceRemaining() ?? 110) <= 100) {
          _finishNavigation();
        }

        if (progressEvent.currentStepInstruction != null) {}
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        isNavigating.value = true;
        break;
      case MapBoxEvent.route_build_failed:
        isNavigating.value = false;
        break;
      case MapBoxEvent.navigation_finished:
        isNavigating.value = false;
        _finishNavigation();
        Get.offAndToNamed(Routes.ONGOING_TRIP);
        break;
      case MapBoxEvent.navigation_cancelled:
        isNavigating.value = false;
        Get.offAndToNamed(Routes.ONGOING_TRIP);
        break;
      default:
        break;
    }
  }

  void _finishNavigation() async {
    try {
      isNavigating.value = false;
      _directions.finishNavigation();
      print("Attempting to finish navigation");
      _directions.finishNavigation();
      print("Navigation finished");
      isNavigating.value = false;
      MapBoxNavigation.instance.finishNavigation();
      print("isNavigating set to false");
      Get.offAndToNamed(Routes.ONGOING_TRIP);
    } catch (error) {
      print("Error finishing navigation: $error");
    }
  }
}
