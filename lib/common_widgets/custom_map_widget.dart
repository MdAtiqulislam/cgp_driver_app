import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:get/get.dart';

class CustomMapWidget extends StatefulWidget {
  final WayPoint origin;
  final WayPoint destination;
  final GlobalKey<CustomMapWidgetState> globalKey;

  const CustomMapWidget({
    Key? key,
    required this.globalKey,
    required this.origin,
    required this.destination,
  }) : super(key: globalKey);

  @override
  CustomMapWidgetState createState() => CustomMapWidgetState();
}

class CustomMapWidgetState extends State<CustomMapWidget> {
  late MapBoxNavigationViewController _controller;
  bool _isMapInitialized = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap().then((value){startNavigation();});
    });
  }

  Future<void> _initializeMap() async {
    if (_isMapInitialized) return; // Avoid redundant initialization

    try {
      await _controller.initialize();
      await _controller.buildRoute(
        wayPoints: [widget.origin, widget.destination],
        options: MapBoxOptions(
          allowsUTurnAtWayPoints: true,
          mode: MapBoxNavigationMode.drivingWithTraffic,
          voiceInstructionsEnabled: true,
          bannerInstructionsEnabled: true,
        ),
      );
      setState(() {
        _isMapInitialized = true;
      });
    } catch (e) {
      //
    }
  }

  Future<void> startNavigation() async {
    if (!_isMapInitialized) {
      return;
    }

    if (_isNavigating) {
      return;
    }

    try {
      await _controller.startNavigation();
      setState(() {
        _isNavigating = true;
      });
    } catch (e) {
      //
    }
  }

  Future<void> stopNavigation() async {
    if (!_isNavigating) {
      return;
    }

    try {
      await _controller.finishNavigation();
      setState(() {
        _isNavigating = false;
      });
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    if (_isMapInitialized) {
      _controller.clearRoute();
      _controller.finishNavigation();
    }
    _controller.dispose();
    super.dispose();
  }

  void _onMapCreated(MapBoxNavigationViewController controller) {
    _controller = controller;
    _initializeMap();
  }

  Future<void> _onRouteEvent(e) async {
    switch (e.eventType) {
      case MapBoxEvent.route_built:
     // _controller.startNavigation();
        break;
      case MapBoxEvent.navigation_finished:
        Get.offAndToNamed(Routes.ONGOING_TRIP);
      // Handle navigation finished
        break;
      case MapBoxEvent.navigation_cancelled:
        Get.offAndToNamed(Routes.ONGOING_TRIP);
      // Handle navigation cancelled
        break;
      default:
      // Handle other events
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapBoxNavigationView(
      onCreated: _onMapCreated,
      onRouteEvent: _onRouteEvent,
      options: MapBoxOptions(),
    );
  }
}
