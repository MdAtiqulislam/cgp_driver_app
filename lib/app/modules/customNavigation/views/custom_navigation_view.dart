
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import '../controllers/custom_navigation_controller.dart';
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';

class CustomNavigationView extends GetView<CustomNavigationController> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CustomNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Stack(
          children: [
            MapBoxNavigationView(
              options: MapBoxOptions(
                initialLatitude: 37.7749,
                initialLongitude: -122.4194,
                zoom: 15.0,
                tilt: 0.0,
                bearing: 0.0,
                enableRefresh: false,
                alternatives: true,
                voiceInstructionsEnabled: true,
                bannerInstructionsEnabled: true,
                allowsUTurnAtWayPoints: true,
                mode: MapBoxNavigationMode.drivingWithTraffic,
                units: VoiceUnits.metric,
                simulateRoute: true,

                language: "en",
              ),
              onRouteEvent: controller.onRouteEvent,
              onCreated: controller.onMapCreated,
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 100,
                width: 100,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}*/


/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../controllers/custom_navigation_controller.dart';

class CustomNavigationView extends GetView<CustomNavigationController> {
  const CustomNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Stop navigation first
        await controller.stopNavigation();
        // Then go back safely
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(),
          body: Obx(() {
            if (!controller.isInitialized.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return MapBoxNavigationView(
              options: controller.options,
              onRouteEvent: controller.onRouteEvent,
              onCreated: controller.onMapCreated,
            );
          }),
        ),
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
//import 'package:flutter_mapbox_navigation_plus/flutter_mapbox_navigation_plus.dart';
import 'package:get/get.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import '../controllers/custom_navigation_controller.dart';
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';

class CustomNavigationView extends GetView<CustomNavigationController> {
  CustomNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Obx(() {
          if (!controller.isInitialized.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return MapBoxNavigationView(
            options: MapBoxOptions(
              initialLatitude:
              controller.currentLocation.value.latitude ?? 0.0,
              initialLongitude:
              controller.currentLocation.value.longitude ?? 0.0,
              zoom: 15.0,
              tilt: 0.0,
              bearing: 0.0,
              mode: MapBoxNavigationMode.drivingWithTraffic,
              units: VoiceUnits.metric,
              simulateRoute: false,
              language: "en-GB",
            ),
            onRouteEvent: controller.onRouteEvent,
            onCreated: controller.onMapCreated,
          );
        }),
      ),
    );
  }
}