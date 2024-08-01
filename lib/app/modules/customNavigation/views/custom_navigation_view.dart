import 'package:flutter/material.dart';
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
        key: scaffoldKey,
        body: Obx(() {
          if (controller.isNavigating.isFalse) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  double destinationLat = 23.915522;  // Replace with dynamic destination latitude
                  double destinationLng = 90.392962;  // Replace with dynamic destination longitude
                  controller.startNavigation(destinationLat, destinationLng);
                },
                child: Text("Start Navigation"),
              ),
            );
          } else {
            return Stack(
              children: [
                MapBoxNavigationView(
                  options: controller.options,
                  onRouteEvent: controller.onRouteEvent,
                  onCreated: (MapBoxNavigationViewController controller) {
                    controller.initialize();
                  },
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Obx(() {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white.withOpacity(0.9),
                      child: Text(
                        controller.routeProgress.value,
                        style: const TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    );
                  }),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.stopNavigation();
                    },
                    child: const Text("Stop Navigation"),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
