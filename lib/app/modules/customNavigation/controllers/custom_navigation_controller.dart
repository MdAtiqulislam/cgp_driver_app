
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
      language: "en",
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
      double destinationLat, double destinationLng) async {
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

        var distance=await _directions.getDistanceRemaining();
        var duration=await _directions.getDurationRemaining();

        Get.find<SocketService>().sendDistanceAndDuration(duration: duration.toString(), distance: distance.toString());

      /*  var distanceInMeter = await calculateDistanceInMeter(destination.value);
        if (distanceInMeter <= 100 ||
            (await _directions.getDistanceRemaining() ?? 310) <= 300) {
          _finishNavigation();
        }*/

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
