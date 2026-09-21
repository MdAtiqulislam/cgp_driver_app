

/*class MapController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

   CameraPosition initialCameraPosition =const CameraPosition(
    target: LatLng(23.911522, 90.388962),
   // zoom: 16.4746,
    zoom: 14.4746,
  );

   @override
  void onInit() async{
    super.onInit();
   await getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }


  void onCameraMove(CameraPosition position) {
    if (position.target.latitude != latitude.value ||
        position.target.longitude != longitude.value) {
      latitude.value = position.target.latitude;
      longitude.value = position.target.longitude;
    }
  }

 Future<void> getCurrentLocation()async{
    LocationServices.getCurrentLocation().then(
          (value) {
        latitude.value=value.latitude;
        longitude.value=value.longitude;
        setCameraPosition();
        return LocationServices.getAddress(
          LatLng(value.latitude, value.longitude),
        );
      },
    );
  }
  void setCameraPosition() async {
    CameraPosition newCameraPosition = CameraPosition(
        target: LatLng(latitude.value, longitude.value),
        //zoom: 16.4746
        zoom: 14.4746
    );
    initialCameraPosition = newCameraPosition;
    final GoogleMapController googleMapController = await mapController.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }
}*/

import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:cgp_driver_app/app/modules/startTrip/controllers/start_trip_controller.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../services/location_services.dart';


class GeneralMapController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoading=false.obs;
  var directionsSteps = <String>[].obs;
  //var isButtonEnabled=false.obs;
  var closerToDestination=false.obs;
  StreamSubscription<Position>? positionStreamSubscription;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(23.911522, 90.388962),
    zoom: 14.4746,
  );
  var polyLines = <Polyline>{}.obs;
  final Set<Marker> _markers = <Marker>{}.obs;
  BitmapDescriptor? destinationIcon;
  var pickupPointName="Pickup Point".obs;
  var destinationPointName="Destination Point".obs;
  var isApproved=true.obs;
  @override
  void onInit() async {
    super.onInit();
    await getCurrentLocation();
   await loadCustomMarker();

  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  void onCameraMove(CameraPosition position) {
    if (position.target.latitude != latitude.value ||
        position.target.longitude != longitude.value) {
      latitude.value = position.target.latitude;
      longitude.value = position.target.longitude;
    }
  }

  Future<void> getCurrentLocation() async {
    LocationServices.getCurrentLocation().then(
          (value) {
        latitude.value = value?.latitude??0.0;
        longitude.value = value?.longitude??0.0;
        setCameraPosition();
        return LocationServices.getAddress(
          LatLng(value?.latitude??0.0, value?.longitude??0.0),
        );
      },
    );
  }

  void setCameraPosition() async {
    CameraPosition newCameraPosition = CameraPosition(
      target: LatLng(latitude.value, longitude.value),
      zoom: 14.4746,
    );
    initialCameraPosition = newCameraPosition;
    final GoogleMapController googleMapController = await mapController.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> generateRoute({required LatLng origin,required LatLng destination}) async {
   // polyLines.value={};
    polyLines.clear();

    const String apiKey = 'AIzaSyBprY90fvqn9LQqEhe4mSIyDf1UekyT2Po';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<LatLng> polylinePoints = [];
      directionsSteps.clear();


      if ((data['routes'] as List).isNotEmpty) {
        var points = data['routes'][0]['overview_polyline']['points'];
        polylinePoints = decodePolyline(points);
        addPolyline(polylinePoints);

        var steps = data['routes'][0]['legs'][0]['steps'];
        for (var step in steps) {
          directionsSteps.add(step['html_instructions']);
        }

        addMarkers(origin, destination);
      }
    } else {
      throw Exception('Failed to load route');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return polyline;
  }

  void addPolyline(List<LatLng> points) {
    final String polylineIdVal = 'polyline_${DateTime.now().millisecondsSinceEpoch}';
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: AppColors.primaryColor,
      points: points,
      width: 5,
    );

    polyLines.add(polyline);
  }

  void addMarkers(LatLng origin, LatLng destination) {
    _markers.clear();
    final Marker originMarker = Marker(
      markerId: const MarkerId('origin'),
      position: origin,
      infoWindow:  InfoWindow(title: pickupPointName.value),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    final Marker destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: destination,
      infoWindow:  InfoWindow(title:destinationPointName.value ),
      icon: destinationIcon??BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    _markers.addAll([originMarker, destinationMarker]);
  }

  Set<Marker> get markers => _markers;


  Future<void> loadCustomMarker() async {
    destinationIcon = await _getBitmapDescriptorFromAssetBytes(
      AppImagePath.deliveryVanMarker,
      36, // Width in pixels
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
    return BitmapDescriptor.bytes(resizedBytes);
  }

  Future<void> startNavigation({required LatLng destination}) async {

    pickupPointName.value="My Location";
    destinationPointName.value="Pickup Point";
    final currentLocation = LatLng(latitude.value, longitude.value);
    await generateRoute(origin: currentLocation, destination: destination);
  }

  void startLocationUpdates({required LatLng destination}) {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,//10
    );

    positionStreamSubscription=  Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        destination.latitude, // Define pickupLat and pickupLng as the latitude and longitude of the pickup point
        destination.longitude,
      );

      if (distanceInMeters <= 100) {
        Get.put(StartTripController());

        if(!Get.find<StartTripController>().reachedToDestination.value){
          Get.find<StartTripController>().status.value=TripStatus.closerToDestination;
        }
        Get.find<StartTripController>().isButtonEnabled.value=true;
        /*if(Get.find<StartTripController>().state.value==TripState.delivery){
          Get.find<StartTripController>().activeButton.value=true;
        }
*/
        Get.find<StartTripController>().controlButtonStatus();
       /* isButtonEnabled.value = true;
        closerToDestination.value=true;
        print("Button Activated");*/
      } else {
      //  isButtonEnabled.value = false;
        Get.find<StartTripController>().isButtonEnabled.value=false;
        closerToDestination.value=false;
      }
    });
  }

  void stopLocationUpdates() {
    positionStreamSubscription?.cancel();
    positionStreamSubscription = null;
  }



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

class NavigationApp {
  final String name;
  final String url;
  final Icon icon;

  NavigationApp({
    required this.name,
    required this.url,
    required this.icon,
  });
}
