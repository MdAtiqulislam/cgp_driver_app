import 'dart:async';
import 'package:cgp_driver_app/app/modules/customNavigation/controllers/custom_navigation_controller.dart';
import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_mapbox_navigation/src/models/options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../../utils/delivery_proof_image_upload.dart';
import '../../../routes/app_pages.dart';
import '../../completeTrip/controllers/complete_trip_controller.dart';
import '../../generalMap/general_map_controller.dart';
import '../../home/views/home_view.dart';
import '../../messaging/controllers/messaging_controller.dart';
import '../../tripRequest/models/trip_request_details_model.dart';
import '../../../../services/api_endpoints.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../../utils/enams.dart';
import '../../../../utils/utils.dart';


class OngoingTripController extends GetxController {
  var status = "".obs;
  var isLoading = false.obs;
  var isExpand = true.obs;
  var actionButtonText = "".obs;
  var statusText = "".obs;
  var distance = "".obs;
  var distanceInMeters = 0.0.obs;
  var showNavigationButton = false.obs;
  var showLocation = "pickup".obs;

  var startPoint = const LatLng(0.0, 0.0).obs;
  var destinationPoint = const LatLng(0.0, 0.0).obs;

  var elapsedTime = ''.obs;
  Timer? timer;
  int totalSeconds = 0;
  var showTimer = false.obs;

  var tripRequestDetails = TripRequestDetailsModel().obs;
  final GeneralMapController mapController = Get.put(GeneralMapController());
  StreamSubscription<Position>? positionStream;

  String nextStatus = "";

 late MapBoxOptions navigationOption;
  var _platformVersion="".obs;

  var isButtonEnabled=true.obs;




  @override
  void onClose() {
    positionStream?.cancel();
    stopTimer();
  }

  Future<void> handleStatus({String? nextStatus}) async {
    var status = nextStatus ?? tripRequestDetails.value.data?.status ?? "";

    if (status.isEmpty) {
      LocalServices.storeOnGoingTrip(null);
      Get.offAndToNamed(Routes.HOME);
      return;
    }

    if (status == OrderStatus.accepted.name) {
      await handleAcceptedStatus();
    } else if (status == OrderStatus.reachedAtPickupPoint.name) {
      await handleReachedAtPickupPointStatus();
    } else if (status == OrderStatus.pickedUp.name) {
      await handlePickedUpStatus();
    } else if (status == OrderStatus.reachedAtDeliveryPoint.name) {
      await handleReachedAtDeliveryPointStatus();
    } else if (status == OrderStatus.delivered.name) {
      await handleDeliveredStatus();
    }
  }

  Future<void> handleAcceptedStatus() async {
    showNavigationButton.value = true;
    distanceInMeters.value=200;
    statusText.value = "Moving to Pickup point";
    actionButtonText.value = "Moving to Pickup point";
    nextStatus = OrderStatus.reachedAtPickupPoint.name;
    destinationPoint.value = LatLng(
      tripRequestDetails.value.data?.pickupLocation?.latitude ?? 0.0,
      tripRequestDetails.value.data?.pickupLocation?.longitude ?? 0.0,
    );
    Get.find<GeneralMapController>().startNavigation(destination: destinationPoint.value);
    var currentLocation = await getCurrentLocation();
    startPoint.value = LatLng(currentLocation.latitude, currentLocation.longitude);

    positionStream?.cancel();
    getDistanceFromCurrentLocation(destination: destinationPoint.value);
  }

  Future<void> handleReachedAtPickupPointStatus() async {
    nextStatus = OrderStatus.pickedUp.name;
    startPoint.value = LatLng(
      tripRequestDetails.value.data?.pickupLocation?.latitude ?? 0.0,
      tripRequestDetails.value.data?.pickupLocation?.longitude ?? 0.0,
    );
    destinationPoint.value = LatLng(
      tripRequestDetails.value.data?.dropOffLocation?.latitude ?? 0.0,
      tripRequestDetails.value.data?.dropOffLocation?.longitude ?? 0.0,
    );

    showNavigationButton.value = false;
    showTimer.value = true;
    startTimer();
    actionButtonText.value = "Picked up";
    statusText.value = "Waiting at Pickup point";
  }

  Future<void> handlePickedUpStatus() async {
    showLocation.value = "destination";
    showNavigationButton.value = true;
    distanceInMeters.value=200;
    actionButtonText.value = "Moving to Destination point";
    statusText.value = "Picked up and moving to destination point";
    nextStatus = OrderStatus.reachedAtDeliveryPoint.name;
    showTimer.value = false;
    stopTimer();

    destinationPoint.value = LatLng(
      tripRequestDetails.value.data?.dropOffLocation?.latitude ?? 0.0,
      tripRequestDetails.value.data?.dropOffLocation?.longitude ?? 0.0,
    );

    startPoint.value = LatLng(
      tripRequestDetails.value.data?.pickupLocation?.latitude ?? 0.0,
      tripRequestDetails.value.data?.pickupLocation?.longitude ?? 0.0,
    );

    Get.find<GeneralMapController>().startNavigation(destination: destinationPoint.value);
    positionStream?.cancel();
    getDistanceFromCurrentLocation(destination: destinationPoint.value);
  }

  Future<void> handleReachedAtDeliveryPointStatus() async {
    nextStatus = OrderStatus.delivered.name;
    positionStream?.cancel();
    showNavigationButton.value = false;
    showTimer.value = true;
    startTimer();
    actionButtonText.value = "Delivered";
    statusText.value = "Waiting at destination point";
  }

  Future<void> handleDeliveredStatus() async {
    nextStatus = OrderStatus.completed.name;
    positionStream?.cancel();
    showNavigationButton.value = false;
    actionButtonText.value = "Trip Completed";
    statusText.value = "Completed";
  }
  
  

  Future<void> changeOrderStatus({String? status, bool? shouldReload}) async {
    if (nextStatus != OrderStatus.waitingAtDestinationPoint.name) {
      isLoading.value = shouldReload ?? true;
      var endPoint = APIEndPoints.changeTripStatus.replaceAll("{id}", tripRequestDetails.value.data?.id ?? "");
      var parameters = {"status": status ?? nextStatus};

      try {
        var data = await RemoteServices.putRequest(endPoint: endPoint, parameters: parameters);

        if (data != null) {
          tripRequestDetails.value = TripRequestDetailsModel.fromJson(data);
          if (status == OrderStatus.delivered.name || nextStatus == OrderStatus.delivered.name) {
            await Future.delayed(const Duration(milliseconds: 500));
            Navigator.of(Get.context!).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeView()),
                  (route) => false,
            );
            await LocalServices.storeOnGoingTrip(null);
            Get.find<SocketService>().updateOrderId("");
            Get.toNamed(Routes.COMPLETE_TRIP);
            Get.put(CompleteTripController());
            Get.find<CompleteTripController>().tripRequestDetails.value = tripRequestDetails.value;
            showDeliveryProofDialog(Get.context!, "${tripRequestDetails.value.data?.deliveryId??""}");
          } else {
            handleStatus();
          }
        }
      } finally {
        isLoading.value = false;
      }
    } else {
      handleStatus();
    }
  }

  Future<void> getDistanceFromCurrentLocation({required LatLng destination}) async {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen((Position position) async {
      distance.value = calculateDistance(LatLng(position.latitude, position.longitude), destination);

      distanceInMeters.value = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        destination.latitude,
        destination.longitude,
      );
      if (distanceInMeters.value <= 150) {
        if (nextStatus == OrderStatus.reachedAtPickupPoint.name) {
          actionButtonText.value = "Arrived at pickup point";
        } else if (nextStatus == OrderStatus.reachedAtDeliveryPoint.name) {
          actionButtonText.value = "Arrived at destination point";
        }
      }
/*      if(distanceInMeters.value<=150 && showNavigationButton.value){
        isButtonEnabled.value=true;
      }else {
        print("Button disabled");
        isButtonEnabled.value=false;
      }*/

    });
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

  Future<void> openNavigationApps({required BuildContext context}) async {
    final List<NavigationApp> availableApps = await getAvailableNavigationApps(startPoint.value, destinationPoint.value);

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
              children: [
                // Your "Tradebar Navigation" button

                ListTile(
                  leading: const Icon(Icons.navigation, color: AppColors.primaryColor),
                  title: const Text('Tradebar Navigation'),
                  onTap: () async {
                    Get.put(CustomNavigationController());
                  //  Get.find<CustomNavigationController>().destination=destinationPoint.value;
                    /*Get.find<CustomNavigationController>().generateRoute(
                        origin: startPoint.value,
                        destination: destinationPoint.value
                    );*/
                   // Get.find<CustomNavigationController>().addMarkers(startPoint.value, destinationPoint.value);
                    Get.find<CustomNavigationController>().startNavigation(destinationPoint.value.latitude,destinationPoint.value.longitude);

                    if (kDebugMode) {
                      print("StartPoint:$startPoint, endpoint:$destinationPoint");
                    }
                    Get.toNamed(Routes.CUSTOM_NAVIGATION);
                     },
                ),
                const Divider(),
                // List of available navigation apps
                ...availableApps.map((app) {
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
              ],
            ),

            /*ListBody(
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
            ),*/
          ),
        );
      },
    );
  }

  void startTimer() {
    stopTimer();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalSeconds++;
      elapsedTime.value = formatWaitingTime(Duration(seconds: totalSeconds));
    });
  }

  void stopTimer() {
    timer?.cancel();
    totalSeconds = 0;
    timer = null;
  }


  cancelOrder({required String title, required String message}) async {
    await LocalServices.storeOnGoingTrip(null);
    Get.find<SocketService>().updateOrderId("");
    Get.offAndToNamed(Routes.HOME);

    showDialog(
        context: Get.context!,
        builder: (buildContext) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w, //AppDimensions.horizontalPadding,
                vertical: 24.h, //AppDimensions.verticalPadding
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  const CustomCircleAvatar(width: 50, height: 50, image: AppImagePath.warningIcon),
                     HeaderText(
                      text: title,
                      maxLine: 10,
                      align: TextAlign.center,
                    ),
                    SizedBox(
                      height: AppDimensions.sectionPadding.h,
                    ),
                     BodyText(text: message),
                    SizedBox(
                      height: AppDimensions.sectionPadding.h,
                    ),
                    AppButton(text: "Dismiss",
                        bgColor: AppColors.primaryColor,
                        onTap: (){
                      Get.back();

                    }),
                    SizedBox(
                      height: AppDimensions.sectionPadding.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        });


  }



  void initMessaging(){
    Get.put(MessagingController());
    Get.find<MessagingController>().initValue();
    Get.find<MessagingController>().imageLink.value =
       tripRequestDetails.value.data
            ?.requestFrom?.url ??
            "";
    Get.find<MessagingController>().chatWith.value=tripRequestDetails.value.data
        ?.requestFrom?.name ??
        "";
    Get.find<MessagingController>().orderDetails.value=tripRequestDetails.value;
  }



  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

  navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    navigationOption.simulateRoute = true;
   // navigationOption.language = "en";
    //_navigationOption.initialLatitude = 36.1175275;
    //_navigationOption.initialLongitude = -115.1839524;
    // MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

  _platformVersion.value = platformVersion??"";
  }

}
