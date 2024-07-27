/*

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';

class CustomNavigationController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(23.911522, 90.388962), // Placeholder coordinates
    zoom: 14.0,
  );

  late LatLng origin;
  late LatLng destination;
  var polyLines = <Polyline>[].obs;
  var markers = <Marker>[].obs;
  BitmapDescriptor? destinationIcon;
  LatLng? currentPosition;

  var isLoading = false.obs;

  StreamSubscription<LocationData>? locationSubscription;

  @override
  Future<void> onInit() async {
    super.onInit();
   await loadCustomMarker();
   startNavigation(origin: origin, destination: destination);
    _setInitialCameraPosition();
  }

  @override
  void onClose() {
    locationSubscription?.cancel();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
    _moveCameraToCurrentPosition();
  }

  Future<void> _setInitialCameraPosition() async {
    final location = Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission == PermissionStatus.granted || hasPermission == PermissionStatus.grantedLimited) {
      final currentLocation = await location.getLocation();
      currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      initialCameraPosition = CameraPosition(
        target: currentPosition!,
        zoom: 14.0,
      );
      update(); // Notify listeners to rebuild the UI with the new camera position
      _moveCameraToCurrentPosition();
    } else {
      await location.requestPermission();
      _setInitialCameraPosition(); // Retry after requesting permission
    }
  }

  Future<void> _moveCameraToCurrentPosition() async {
    if (currentPosition != null) {
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition!, zoom: 14.0),
      ));
    }
  }

  Future<void> loadCustomMarker() async {
    destinationIcon = await _getBitmapDescriptorFromAssetBytes(
      AppImagePath.deliveryVanMarker,
      50,
    );
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromAssetBytes(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List resizedBytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  void startNavigation({
    required LatLng origin,
    required LatLng destination,
  }) {
    polyLines.clear();
    addMarkers(origin, destination);
    generateRoute(origin: origin, destination: destination);
    subscribeToLocationUpdates();
  }

  void subscribeToLocationUpdates() {
    locationSubscription?.cancel();
    locationSubscription = Location().onLocationChanged.listen((LocationData newLocation) async {
      currentPosition = LatLng(newLocation.latitude!, newLocation.longitude!);

      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newLatLng(currentPosition!));

      // Add or update the current location marker
      markers.removeWhere((m) => m.markerId == const MarkerId('currentLocation'));
      markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ));
    });
   // startNavigation(origin: origin, destination: destination);
  }

  Future<void> generateRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    isLoading.value = true;
    polyLines.clear();

    const String apiKey = 'AIzaSyCUqRnsyjWiluojL3z2-9VRoZ7ABubgbpE';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<LatLng> polylinePoints = [];

        if ((data['routes'] as List).isNotEmpty) {
          final String points = data['routes'][0]['overview_polyline']['points'];
          polylinePoints.addAll(decodePolyline(points));

          addPolyline(polylinePoints);



        }
      }
    } catch (e) {
      print('Error generating route: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    final List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return polyline;
  }

  void addPolyline(List<LatLng> points) {
    if (points.isEmpty) {
      return;
    }

    final String polylineIdVal = 'polyline_${DateTime.now().millisecondsSinceEpoch}';
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: AppColors.primaryColor,
      points: points,
      width: 5,
    );

    polyLines.add(polyline);
    polyLines = polyLines.toSet().toList().obs; // Update the polyLines list to refresh the map
  }

  void addMarkers(LatLng origin, LatLng destination) {
    markers.clear();

    final Marker originMarker = Marker(
      markerId: const MarkerId('origin'),
      position: origin,
      infoWindow: const InfoWindow(title: "Pickup Point"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    final Marker destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: destination,
      infoWindow: const InfoWindow(title: "Destination Point"),
      icon: destinationIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    markers.add(originMarker);
    markers.add(destinationMarker);

    // Update the markers list to refresh the map
    markers.refresh();
  }

}

 */



/*
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class CustomNavigationController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(23.911522, 90.388962),
    zoom: 14.0,
  );

  late LatLng origin;
  late LatLng destination;
  var polyLines = <Polyline>[].obs;
  var markers = <Marker>[].obs;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? navigationIcon;
  LatLng? currentPosition;
  var isLoading = false.obs;
  StreamSubscription<LocationData>? locationSubscription;
  var steps = <String>[].obs;
  var currentStepIndex = 0.obs;

  final FlutterTts flutterTts = FlutterTts();

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadCustomMarker();
    await setInitialLocation();
    if (origin != null && destination != null) {
      startNavigation(origin: origin, destination: destination);
    }
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
  }

  @override
  void onClose() {
    locationSubscription?.cancel();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
    moveCameraToCurrentPosition();
  }

  Future<void> setInitialLocation() async {
    final location = Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission == PermissionStatus.granted || hasPermission == PermissionStatus.grantedLimited) {
      final currentLocation = await location.getLocation();
      currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      initialCameraPosition = CameraPosition(
        target: currentPosition!,
        zoom: 14.0,
      );
      update();
      moveCameraToCurrentPosition();
    } else {
      await location.requestPermission();
      setInitialLocation();
    }
  }

  Future<void> moveCameraToCurrentPosition() async {
    if (currentPosition != null) {
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition!, zoom: 14.0),
      ));
    }
  }

  Future<void> loadCustomMarker() async {
    destinationIcon = await getBitmapDescriptorFromAssetBytes(
      'assets/delivery_van_marker.png',
      50,
    );
    navigationIcon = await getBitmapDescriptorFromAssetBytes(
      'assets/navigation_icon.png',
      50,
    );
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List resizedBytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  void startNavigation({
    required LatLng origin,
    required LatLng destination,
  }) {
    polyLines.clear();
    steps.clear();
    currentStepIndex.value = 0;
    addMarkers(origin, destination);
    generateRoute(origin: origin, destination: destination);
    subscribeToLocationUpdates();
  }

  void subscribeToLocationUpdates() {
    locationSubscription?.cancel();
    locationSubscription = Location().onLocationChanged.listen((LocationData newLocation) async {
      currentPosition = LatLng(newLocation.latitude!, newLocation.longitude!);

      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newLatLng(currentPosition!));

      final double bearing = calculateBearing(currentPosition!, destination);
      markers.removeWhere((m) => m.markerId == const MarkerId('currentLocation'));
      update();

      // Check if the user has reached the end of the current step
      if (currentStepIndex.value < steps.length - 1) {
        _speak(steps[currentStepIndex.value]);
        currentStepIndex.value++;
      }
    });
  }

  Future<void> generateRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    isLoading.value = true;
    polyLines.clear();

    const String apiKey = 'AIzaSyCUqRnsyjWiluojL3z2-9VRoZ7ABubgbpE';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<LatLng> polylinePoints = [];

        if ((data['routes'] as List).isNotEmpty) {
          final String points = data['routes'][0]['overview_polyline']['points'];
          polylinePoints.addAll(decodePolyline(points));

          addPolyline(polylinePoints);
          // Extract steps
          final List stepsData = data['routes'][0]['legs'][0]['steps'];
          for (var step in stepsData) {
            String instruction = step['html_instructions'].toString().replaceAll(RegExp(r'<[^>]*>'), '');
            steps.add(instruction);
          }
          if (steps.isNotEmpty) {
            _speak(steps[0]); // Speak the first instruction
          }
        }
      }
    } catch (e) {
      print('Error generating route: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    final List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return polyline;
  }

  void addPolyline(List<LatLng> points) {
    if (points.isEmpty) {
      return;
    }

    final String polylineIdVal = 'polyline_${DateTime.now().millisecondsSinceEpoch}';
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blue,
      points: points,
      width: 5,
    );

    polyLines.add(polyline);
  }

  void addMarkers(LatLng origin, LatLng destination) {
    markers.clear();

    final Marker originMarker = Marker(
      markerId: const MarkerId('origin'),
      position: origin,
      infoWindow: const InfoWindow(title: "Pickup Point"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    final Marker destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: destination,
      infoWindow: const InfoWindow(title: "Destination Point"),
      icon: destinationIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    markers.add(originMarker);
    markers.add(destinationMarker);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  double calculateBearing(LatLng start, LatLng end) {
    double startLat = start.latitude * (pi / 180);
    double startLng = start.longitude * (pi / 180);
    double endLat = end.latitude * (pi / 180);
    double endLng = end.longitude * (pi / 180);

    double dLng = endLng - startLng;
    double dPhi = log(tan(endLat / 2.0 + pi / 4.0) / tan(startLat / 2.0 + pi / 4.0));
    if (dLng.abs() > pi) {
      dLng = dLng > 0 ? -(2.0 * pi - dLng) : (2.0 * pi + dLng);
    }

    double bearing = (atan2(dLng, dPhi) * 180 / pi + 360) % 360;
    return bearing;
  }
}




*/


/*
import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';


class CustomNavigationController extends GetxController {
  late MapBoxNavigation _directions;
  late MapBoxOptions options;
  late LatLng origin;
  late LatLng destination;
  var isLoading = false.obs;
  var steps = <String>[].obs;
  var currentStepIndex = 0.obs;
  final FlutterTts flutterTts = FlutterTts();
  final location = Location();
  LocationData? currentLocation;
  late StreamSubscription<LocationData> locationSubscription;
  var isNavigating = false.obs;
  var routeProgress = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await setInitialLocation();
    _directions = MapBoxNavigation();
    options = MapBoxOptions(
      initialLatitude: currentLocation!.latitude!,
      initialLongitude: currentLocation!.longitude!,
      zoom: 15.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.driving,
      units: VoiceUnits.metric,
    );
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
  }

  @override
  void onClose() {
    locationSubscription.cancel();
    super.onClose();
  }

  Future<void> setInitialLocation() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.grantedLimited) {
      currentLocation = await location.getLocation();
      origin = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      destination = LatLng(23.7956, 90.4262); // Set your destination here
    } else {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.granted ||
          permissionStatus == PermissionStatus.grantedLimited) {
        currentLocation = await location.getLocation();
        origin = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
        destination = LatLng(23.7956, 90.4262); // Set your destination here
      }
    }
  }

  void startNavigation() {
    var wayPoints = <WayPoint>[
      WayPoint(name: "Current Location", latitude: origin.latitude, longitude: origin.longitude),
      WayPoint(name: "Destination", latitude: destination.latitude, longitude: destination.longitude),
    ];
    _directions.startNavigation(wayPoints: wayPoints, options: options);
    isNavigating.value = true;
  }

  void stopNavigation() {
    _directions.finishNavigation();
    isNavigating.value = false;
  }

  void _onRouteEvent(e) {
    if (e.eventType == MapBoxEvent.progress_change) {
      var progressEvent = e.data as RouteProgressEvent;
      routeProgress.value = progressEvent.currentStepInstruction ?? '';
      _speak(routeProgress.value);
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }
}

*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

class TurnByTurn extends StatefulWidget {
  const TurnByTurn({Key? key}) : super(key: key);

  @override
  State<TurnByTurn> createState() => _TurnByTurnState();
}

class _TurnByTurnState extends State<TurnByTurn> {
  // Waypoints to mark trip start and end
  late WayPoint sourceWaypoint, destinationWaypoint;
  var wayPoints = <WayPoint>[];

  // Config variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  late double distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;
  final bool isMultipleStop = false;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (!mounted) return;

    // Setup directions and options
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
      zoom: 18.0,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      isOptimized: true,
      units: VoiceUnits.metric,
      simulateRoute: true,
      language: "en",
    );

    // Configure waypoints
    sourceWaypoint = WayPoint(
      name: "Source",
      latitude: 23.911522, // replace with your source latitude
      longitude: 90.388962, // replace with your source longitude
    );
    destinationWaypoint = WayPoint(
      name: "Destination",
      latitude: 23.8103, // replace with your destination latitude
      longitude: 90.4125, // replace with your destination longitude
    );
    wayPoints.add(sourceWaypoint);
    wayPoints.add(destinationWaypoint);

    // Start the trip
    await directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  Future<void> _onRouteEvent(MapBoxEvent e) async {
    distanceRemaining = (await directions.getDistanceRemaining()) ?? 0;
    durationRemaining = (await directions.getDurationRemaining()) ?? 0;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Turn by Turn Navigation')),
      body: Center(
        child: Text('Distance Remaining: $distanceRemaining\nDuration Remaining: $durationRemaining\nInstruction: $instruction'),
      ),
    );
  }
}



*/





import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

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

    options = MapBoxOptions(
      initialLatitude: currentLocation.value.latitude!,
      initialLongitude: currentLocation.value.longitude!,
      zoom: 14.0,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      simulateRoute: false,
      language: "en",
    );

    isNavigating.value = true;
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






