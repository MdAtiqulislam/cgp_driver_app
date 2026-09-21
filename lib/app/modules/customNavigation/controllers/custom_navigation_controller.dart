/*
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../services/socket_service.dart';
import '../../../routes/app_pages.dart';

class CustomNavigationController extends GetxController {
  late MapBoxNavigation _directions;
  late MapBoxNavigationViewController _controller;
  late MapBoxOptions options;
  var isNavigating = false.obs;
  var routeProgress = "".obs;
  var currentLocation =
      LocationData.fromMap({"latitude": 0.0, "longitude": 0.0}).obs;
  var isInitialized = false.obs;

  var origin = const LatLng(0.0, 0.0).obs;
  var destination = const LatLng(0.0, 0.0).obs;

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
      language: "en-GB",
      units: VoiceUnits.metric,

    );
    _directions = MapBoxNavigation();
    _initializeLocation();

    // Subscribe to events
    _directions.registerRouteEventListener(onRouteEvent);
  }

  void onMapCreated(MapBoxNavigationViewController controller) {
      _controller = controller;
    _initializeMap();
  }

  void _initializeMap() async {


    try {
      await _controller.initialize();
      await _controller.buildRoute(
        wayPoints: [
          WayPoint(name: "origin", latitude: currentLocation.value.latitude, longitude: currentLocation.value.longitude),
          WayPoint(name: "destination", latitude: destination.value.latitude, longitude: destination.value.longitude)
        ],
        options: MapBoxOptions(
          allowsUTurnAtWayPoints: true,
          mode: MapBoxNavigationMode.drivingWithTraffic,
          voiceInstructionsEnabled: true,
          bannerInstructionsEnabled: false,
          units: VoiceUnits.metric,
          enableRefresh: true,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing MapBox: $e');
      }
    }
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
      double destinationLat, double destinationLng) async
  {
    destination.value = LatLng(destinationLat, destinationLng);
    if (!isInitialized.value) {
      print("Checking");
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

        var distance=await _directions.getDistanceRemaining();
        var duration=await _directions.getDurationRemaining();

        Get.find<SocketService>().sendDistanceAndDuration(duration: duration.toString(), distance: distance.toString());

      */
/*  var distanceInMeter = await calculateDistanceInMeter(destination.value);
        if (distanceInMeter <= 100 ||
            (await _directions.getDistanceRemaining() ?? 310) <= 300) {
          _finishNavigation();
        }*//*


        if (progressEvent.currentStepInstruction != null) {}
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        isNavigating.value = true;
        //_directions.startNavigation(wayPoints: way);
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
      if (kDebugMode) {
        print("Attempting to finish navigation");
      }
      _directions.finishNavigation();
      if (kDebugMode) {
        print("Navigation finished");
      }
      isNavigating.value = false;
      MapBoxNavigation.instance.finishNavigation();
      if (kDebugMode) {
        print("isNavigating set to false");
      }
      Get.offAndToNamed(Routes.ONGOING_TRIP);
    } catch (error) {
      if (kDebugMode) {
        print("Error finishing navigation: $error");
      }
    }
  }
}


*/



import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_mapbox_navigation_plus/flutter_mapbox_navigation_plus.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../services/socket_service.dart';
import '../../../routes/app_pages.dart';

class CustomNavigationController extends GetxController {
  late MapBoxNavigation _directions;
  MapBoxNavigationViewController? _viewController;

  late MapBoxOptions options;

  var isNavigating = false.obs;
  var routeProgress = "".obs;
  var isInitialized = false.obs;

  var currentLocation =
      LocationData.fromMap({"latitude": 0.0, "longitude": 0.0}).obs;

  var destination = const LatLng(0.0, 0.0).obs;

  @override
  void onInit() {
    super.onInit();

    _directions = MapBoxNavigation();

    options = MapBoxOptions(
      zoom: 14.0,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      simulateRoute: true,
      enableRefresh: true,
      showEndOfRouteFeedback: false,
      showReportFeedbackButton: false,
      language: "en-GB",
      units: VoiceUnits.metric,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,//Platform.isAndroid,
      allowsUTurnAtWayPoints: true,
    );

    _initializeLocation();

    _directions.registerRouteEventListener(onRouteEvent);
  }

  // ================= LOCATION =================

  Future<void> _initializeLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      print("Location service not enabled, requesting...");
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    /// 🔥 Wait until valid coordinate পাওয়া যায়
    location.onLocationChanged.listen((LocationData data) {
      print("Live Lat: ${data.latitude}");

      if (data.latitude != null && data.longitude != null) {
        currentLocation.value = data;
        isInitialized.value = true;
      }
    });

    LocationData locationData = await location.getLocation();

    if (locationData.latitude != null &&
        locationData.longitude != null) {
      currentLocation.value = locationData;
      isInitialized.value = true;
    }
  }

  // ================= VIEW CREATED =================

  void onMapCreated(MapBoxNavigationViewController controller) async {
    _viewController = controller;

    if (Platform.isAndroid) {
      await _viewController?.initialize();
    }
  }

  // ================= START NAVIGATION =================

  Future<void> startNavigation(
      double destinationLat, double destinationLng) async {

    print("..........................");
    destination.value = LatLng(destinationLat, destinationLng);

    /// 🛑 Proper iOS-safe location check
    if (!isInitialized.value ||
        currentLocation.value.latitude == null ||
        currentLocation.value.longitude == null) {

      print("Waiting for valid location...");
      await Future.delayed(const Duration(seconds: 1));
      return startNavigation(destinationLat, destinationLng);
    }

    var wayPoints = <WayPoint>[
      WayPoint(
        name: "Start",
        latitude: currentLocation.value.latitude!,
        longitude: currentLocation.value.longitude!,
      ),
      WayPoint(
        name: "End",
        latitude: destinationLat,
        longitude: destinationLng,
      ),
    ];

    isNavigating.value = true;

    print(wayPoints);
    if (Platform.isIOS) {
      await MapBoxNavigation.instance.startNavigation(
        wayPoints: wayPoints,
        options: options,
      );

    } else {

      /*_directions.setDefaultOptions(options);

      await _directions.startNavigation(
        wayPoints: wayPoints,
        options: options,
      );*/
      await MapBoxNavigation.instance.startNavigation(
        wayPoints: wayPoints,
        options: options,
      );
    }
  }

  // ================= STOP =================

  Future<void> stopNavigation() async {
    await _directions.finishNavigation();
    isNavigating.value = false;
  }

  // ================= ROUTE EVENTS =================

  Future<void> onRouteEvent(RouteEvent? e) async {
    try {
      /// 🛑 Null guard (plugin bug protection)
      if (e == null) return;
      if (e.eventType == null) return;

      routeProgress.value = e.eventType.toString();

      switch (e.eventType) {

        case MapBoxEvent.progress_change:

        /// 🔥 iOS safe distance handling
          try {
            final distance = await _directions.getDistanceRemaining() ?? 0;
            final duration = await _directions.getDurationRemaining() ?? 0;

            if (distance > 0 && duration > 0) {
              Get.find<SocketService>().sendDistanceAndDuration(
                duration: duration.toString(),
                distance: distance.toString(),
              );
            }
          } catch (error) {
            if (kDebugMode) {
              print("Progress error: $error");
            }
          }
          break;

        case MapBoxEvent.route_building:
          if (kDebugMode) {
            print("Route building...");
          }
          break;

        case MapBoxEvent.route_built:
          isNavigating.value = true;
          break;

        case MapBoxEvent.route_build_failed:
          isNavigating.value = false;
          break;

        case MapBoxEvent.navigation_finished:
        case MapBoxEvent.navigation_cancelled:
           _finishNavigation();
          break;

        default:
          break;
      }

    } catch (error) {
      /// 🛑 Final crash guard (important for iOS)
      if (kDebugMode) {
        print("RouteEvent Crash Prevented: $error");
      }
    }
  }

  void _finishNavigation() async {

    print("Navigation finished");
    try {
      isNavigating.value = false;
      await _directions.finishNavigation();
      await MapBoxNavigation.instance.finishNavigation();
      Get.offAndToNamed(Routes.ONGOING_TRIP);
    } catch (e) {
      if (kDebugMode) {
        print("Navigation finish error: $e");
      }
    }
  }
}