/*
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../app/routes/app_pages.dart';

class EmbeddedNavigationScreen extends StatefulWidget {
  final double destinationLatitude;
  final double destinationLongitude;

  EmbeddedNavigationScreen({required this.destinationLatitude, required this.destinationLongitude});

  @override
  _EmbeddedNavigationScreenState createState() => _EmbeddedNavigationScreenState();
}

class _EmbeddedNavigationScreenState extends State<EmbeddedNavigationScreen> {
  late MapBoxNavigationViewController _controller;
  WayPoint? _origin;
  late WayPoint _destination;

  final GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _destination = WayPoint(
      name: "Destination",
      latitude: widget.destinationLatitude,
      longitude: widget.destinationLongitude,
    );
    _setCurrentLocationAsOrigin();
  }
  @override
  void dispose() {
    _controller.finishNavigation();
    _controller.dispose(); // Dispose of the controller

    super.dispose();
  }

  Future<void> _setCurrentLocationAsOrigin() async {
    Position position = await _determinePosition();
    setState(() {
      _origin = WayPoint(
        name: "Origin",
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });
  }

  Future<Position> _determinePosition() async {
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

    // When permission is granted, get the position.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          enableBackButton: true,
          scaffoldKey: scaffoldKey,
        ),
        drawer: MyDrawer(),
        body: Stack(
          children: [
            if (_origin != null)
              MapBoxNavigationView(
                options: MapBoxOptions(
                  initialLatitude: _origin!.latitude,
                  initialLongitude: _origin!.longitude,
                  zoom: 15.0,
                  tilt: 0.0,
                  bearing: 0.0,
                  enableRefresh: false,
                  alternatives: true,
                  voiceInstructionsEnabled: true,
                  bannerInstructionsEnabled: true,
                  allowsUTurnAtWayPoints: true,
                  mode: MapBoxNavigationMode.drivingWithTraffic,
                  units: VoiceUnits.imperial,
                  simulateRoute: true,
                  language: "en",
                ),
                onRouteEvent: _onRouteEvent,
                onCreated: _onMapCreated,
              ),
            if (_origin == null)
              Center(
                child: CircularProgressIndicator(),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 100,
                width: 100,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(MapBoxNavigationViewController controller) {
    setState(() {
      _controller = controller;
    });
    _initializeMap();
  }

  void _initializeMap() async {
    if (_origin != null) {
      try {
        await _controller.initialize();
        await _controller.buildRoute(
          wayPoints: [_origin!, _destination],
          options: MapBoxOptions(
            allowsUTurnAtWayPoints: true,
            mode: MapBoxNavigationMode.drivingWithTraffic,
            voiceInstructionsEnabled: true,
            bannerInstructionsEnabled: true,
          ),
        );
      } catch (e) {
        print('Error initializing MapBox: $e');
      }
    }
  }

  Future<void> _onRouteEvent(e) async {
    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;

        if ((await _controller.distanceRemaining) <= 300) {
          _finishNavigation();
        }

        if (progressEvent.currentStepInstruction != null) {}
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        _controller.startNavigation();
        break;
      case MapBoxEvent.route_build_failed:
        break;
      case MapBoxEvent.navigation_finished:
        Get.offAndToNamed(Routes.ONGOING_TRIP);
        break;
      case MapBoxEvent.navigation_cancelled:
        _cancelNavigation();
        break;
      default:
        break;
    }
  }

  void _finishNavigation() async {
    try {
      print("Attempting to finish navigation");
      print("Navigation finished");
      Get.offAndToNamed(Routes.ONGOING_TRIP);
    } catch (error) {
      print("Error finishing navigation: $error");
    }
  }

  void _cancelNavigation() async {
    Get.offAndToNamed(Routes.ONGOING_TRIP);
    try {
      print("Attempting to cancel navigation");
    } catch (error) {
      print("Error cancelling navigation: $error");
    }
  }
}



 */

import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
//import 'package:flutter_mapbox_navigation_plus/flutter_mapbox_navigation_plus.dart';
import 'package:get/get.dart';

import 'custom_app_bar.dart';
import 'custom_map_widget.dart';

class EmbeddedNavigationScreen extends StatefulWidget {
  final double originLatitude;
  final double originLongitude;
  final double destinationLatitude;
  final double destinationLongitude;

  const EmbeddedNavigationScreen({super.key,
    required this.originLatitude,
    required this.originLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude});

  @override
  _EmbeddedNavigationScreenState createState() => _EmbeddedNavigationScreenState();
}

class _EmbeddedNavigationScreenState extends State<EmbeddedNavigationScreen> {
  final GlobalKey<CustomMapWidgetState> _mapKey = GlobalKey<CustomMapWidgetState>();
  final GlobalKey<ScaffoldState>scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: scaffoldKey,
          minimal: true,
          title: "Ongoing",
          titleTextSize: 14,

        ),
        drawer: MyDrawer(),
        body:  Stack(
          children: [
            CustomMapWidget(
                globalKey: _mapKey,
              destination: WayPoint(
                  name: "destination",
                  latitude: widget.destinationLatitude,
                  longitude: widget.destinationLongitude),
              origin: WayPoint(
                  name: "destination",
                  latitude: widget.originLatitude,
                  longitude: widget.originLongitude),
            ),
          ],
        ),
      ),
    );
  }
}
