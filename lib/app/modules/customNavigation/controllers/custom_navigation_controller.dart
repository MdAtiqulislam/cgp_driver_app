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
