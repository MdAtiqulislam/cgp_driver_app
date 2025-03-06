
import 'dart:async';

import 'package:cgp_driver_app/app/modules/completeTrip/controllers/complete_trip_controller.dart';
import 'package:cgp_driver_app/app/modules/home/views/home_view.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/local_services.dart';
import '../../generalMap/general_map_controller.dart';

class StartTripController extends GetxController {
  var isClientMode = false.obs;
  var isExpand = true.obs;
  var isLoading = false.obs;
  var state = TripState.pickup.obs;
  var status = TripStatus.waiting.obs;
  var actionButtonText = "Reached Pickup Location".obs;
  var reachedToDestination = false.obs;
  var isButtonEnabled = true.obs;
  var tripRequestDetails = TripRequestDetailsModel().obs;
  var pickupDistance = "".obs;
  var pickupDuration = 0.0.obs;
  var buttonColor = AppColors.primaryColor.obs;
  var startPoint=const LatLng(0.0, 0.0).obs;
  var destinationPoint=const LatLng(0.0, 0.0).obs;







  StreamSubscription<Position>? positionStream;

  var destinationPointName="pickup".obs;



  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }



  Future<void> getDistanceFromCurrentLocation({required LatLng destination}) async {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // Update every 10 meters
      ),
    ).listen((Position position) async {
      pickupDistance.value =calculateDistance(LatLng(position.latitude, position.longitude), destination);
      if (kDebugMode) {
        print("pickupDistance $pickupDistance");
      }
    });
  }




  void controlButtonStatus() {
    switch (status.value) {
      case TripStatus.movingToDestination:
        actionButtonText.value = state.value == TripState.pickup
            ? "Start For Destination"
            : "Start For Destination";
        break;
      case TripStatus.closerToDestination:
        if (!reachedToDestination.value) {
          actionButtonText.value = state.value == TripState.pickup
              ? "Arrived at pickup point"
              : "Arrived at Destination";
        }
        break;
      case TripStatus.waiting:
        actionButtonText.value =
            state.value == TripState.pickup ? "Waiting at pickup point" : "Delivered";
        break;
      case TripStatus.completed:
        actionButtonText.value = state.value == TripState.pickup
            ? "Moving to Destination"
            : "Complete Trip";
        break;
    }
  }

  void buttonAction() {

    switch (status.value) {
      case TripStatus.movingToDestination:
        /*if (state.value == TripState.pickup) {
          buttonColor.value = AppColors.errorColor;
         // cancelTrip();
        } else {
          buttonColor.value = AppColors.primaryColor;
        }*/
      status.value=TripStatus.closerToDestination;
        break;
      case TripStatus.closerToDestination:
        reachedDestination();
        break;
      case TripStatus.waiting:
        if (state.value == TripState.pickup) {
          completePickedUp();
        } else {
          completeUnload();
        }
        break;
      case TripStatus.completed:
        controlButtonStatus();
        break;
    }
  }

  void cancelTrip() {}

  void reachedDestination() {
    status.value = TripStatus.waiting;
    reachedToDestination.value = true;
    positionStream?.cancel();
    controlButtonStatus();
  }
  void reachedPickupLocation() {
    status.value = TripStatus.waiting;
    state.value=TripState.pickup;
    reachedToDestination.value = true;
    positionStream?.cancel();
    controlButtonStatus();
  }

  Future<void> completePickedUp() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.changeTripStatus
        .replaceAll("{id}", tripRequestDetails.value.data?.id ?? "");
    var parameters = {"status": "picked_up"};

    try {
      var data = await RemoteServices.putRequest(
          endPoint: endPoint, parameters: parameters);

      if (data != null) {
         destinationPoint.value = LatLng(
          tripRequestDetails.value.data?.dropOffLocation?.latitude ?? 0.0,
          tripRequestDetails.value.data?.dropOffLocation?.longitude ?? 0.0,
        );
         startPoint.value = LatLng(
           tripRequestDetails.value.data?.pickupLocation?.latitude ?? 0.0,
           tripRequestDetails.value.data?.pickupLocation?.longitude ?? 0.0,
         );

        Get.put(GeneralMapController());
        Get.find<GeneralMapController>().stopLocationUpdates();
        await Future.delayed(const Duration(milliseconds: 500));
        getDistanceFromCurrentLocation(destination: destinationPoint.value);
        Get.find<GeneralMapController>().startNavigation(destination: destinationPoint.value);
        Get.find<GeneralMapController>()
            .startLocationUpdates(destination: destinationPoint.value);

        status.value = TripStatus.movingToDestination;
        state.value = TripState.delivery;
        reachedToDestination.value = false;
        isButtonEnabled.value = false;
        destinationPointName.value="destination";
        controlButtonStatus();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeUnload() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.changeTripStatus
        .replaceAll("{id}", tripRequestDetails.value.data?.id ?? "");
    var parameters = {"status": "delivered"};

    try {
      var data = await RemoteServices.putRequest(
          endPoint: endPoint, parameters: parameters);

      if (data != null) {
        status.value = TripStatus.completed;
        state.value = TripState.delivery;
        controlButtonStatus();
        //Get.put(MapController());
        final mapController = Get.find<GeneralMapController>();
        mapController.stopLocationUpdates();
        await Future.delayed(const Duration(milliseconds: 500));

        Navigator.of(Get.context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeView()),
          (route) => false,
        );

        await LocalServices.storeOnGoingTrip(null);

        Get.toNamed(Routes.COMPLETE_TRIP);
        Get.put(CompleteTripController());
        Get.find<CompleteTripController>().tripRequestDetails.value=tripRequestDetails.value;


      }
    } finally {
      isLoading.value = false;
    }
  }

  /*Future<void> openNavigationApps({required LatLng startPoint,required LatLng endPoint,}) async {
    final urlGoogleMaps = 'https://www.google.com/maps/dir/?api=1&origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&travelmode=driving';
    final urlAppleMaps = 'http://maps.apple.com/?saddr=${startPoint.latitude},${startPoint.longitude}&daddr=${endPoint.latitude},${endPoint.longitude}';

    if (await canLaunchUrl(Uri.parse(urlGoogleMaps))) {
      await canLaunchUrl(Uri.parse(urlGoogleMaps));
    } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
      await canLaunchUrl(Uri.parse(urlAppleMaps));
    } else {
      print("Not opening");
      throw 'Could not launch maps';
    }
  }
*/


  Future<void> openNavigationApps({
    required BuildContext context,
    required LatLng startPoint,
    required LatLng endPoint,
  }) async {
    final List<NavigationApp> availableApps = await getAvailableNavigationApps(startPoint, endPoint);

    if (availableApps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No navigation apps available')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Navigation App'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableApps.map((app) {
                return ListTile(
                  leading: app.icon,
                  title: Text(app.name),
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (await canLaunchUrl(Uri.parse(app.url))) {
                      await launchUrl(Uri.parse(app.url));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch ${app.name}')),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<List<NavigationApp>> getAvailableNavigationApps(LatLng startPoint, LatLng endPoint) async {
    final List<NavigationApp> navigationApps = [
      NavigationApp(
        name: 'Google Maps',
        url: 'https://www.google.com/maps/dir/?api=1&origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&travelmode=driving',
        icon: const Icon(Icons.map, color: Colors.blue),
      ),
      NavigationApp(
        name: 'Apple Maps',
        url: 'http://maps.apple.com/?saddr=${startPoint.latitude},${startPoint.longitude}&daddr=${endPoint.latitude},${endPoint.longitude}',
        icon: const Icon(Icons.map, color: Colors.black),
      ),
      NavigationApp(
        name: 'Waze',
        url: 'https://waze.com/ul?ll=${endPoint.latitude},${endPoint.longitude}&navigate=yes',
        icon: const Icon(Icons.directions, color: Colors.purple),
      ),
    ];

    List<NavigationApp> availableApps = [];

    for (var app in navigationApps) {
      if (await canLaunchUrl(Uri.parse(app.url))) {
        availableApps.add(app);
      }
    }

    return availableApps;
  }




}

enum TripStatus { movingToDestination, closerToDestination, waiting, completed }

extension TripStatusExtension on TripStatus {
  String get name {
    switch (this) {
      case TripStatus.movingToDestination:
        return 'movingToDestination';
      case TripStatus.closerToDestination:
        return 'closerToDestination';
      case TripStatus.waiting:
        return 'waiting';
      case TripStatus.completed:
        return 'completed';
    }
  }
}

enum TripState { pickup, delivery }

extension TripStateExtension on TripState {
  String get name {
    switch (this) {
      case TripState.pickup:
        return 'pickup';
      case TripState.delivery:
        return 'delivery';
    }
  }

}
