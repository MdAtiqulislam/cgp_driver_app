import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';

/*  ******Function to pic image***** */
Future<XFile?> picImage(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: imageSource);
  if (file != null) {
    return file;
  } else {
    return null;
  }
}

/*  ******Function to crop image***** */



/*void showDeliveryProofDialog() {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false, // Prevent dialog from closing on back press
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.borderRadius.r),
                topRight: Radius.circular(AppDimensions.borderRadius.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0.h, horizontal: AppDimensions.horizontalPadding.w),
              child: HeaderText(
                text: "Delivery Completed",
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          content: BodyText(
            text: "Do you want to capture a proof image?",
            maxLine: 10,
            size: 14,
          ),
          actions: <Widget>[
            MaterialButton(
              autofocus: true,
              textColor: Colors.white,
              focusColor: AppColors.primaryColor,
              splashColor: AppColors.primaryColor,
              color: AppColors.primaryColor,
              focusElevation: 5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                XFile? image = await picImage(ImageSource.camera); // Open camera
                if (image != null) {
                  print("Captured Image: ${image.path}");
                }
              },
              child: const Text("Yes"),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(12),
              ),
              textColor: AppColors.primaryColor,
              splashColor: AppColors.primaryColor,
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("No"),
            ),
          ],
        ),
      );
    },
  );
}*/




Future<CroppedFile?> cropImage({required String filePath,  CropStyle? cropStyle}) async {
  return await ImageCropper().cropImage(

    sourcePath: filePath,
    /*   aspectRatioPresets: [
      // CropAspectRatioPreset.square,
      //CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      // CropAspectRatioPreset.ratio4x3,
      //CropAspectRatioPreset.ratio16x9
    ],*/
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Edit',
        toolbarColor: Colors.white,
        toolbarWidgetColor: AppColors.primaryColor,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        cropStyle: cropStyle??CropStyle.circle,
      ),
      IOSUiSettings(
        title: 'Edit',
        cropStyle: cropStyle??CropStyle.circle,
      ),
    ],
  );
}

/*  ******Function to format date***** */

String formatDate(String? date) {
  if (date != null && date.isNotEmpty) {
    DateTime dDate = DateFormat('y-M-d').parse(date);
    return DateFormat("MMM -yy").format(dDate);
  } else {
    return "";
  }
}

/*  ******Function to decoration input fields***** */
InputDecoration inputDecoration(
    {String? hintText,
    String? levelText,
    required bool isRequired,
    Widget? preFix,
    Widget? suffix}) {
  return InputDecoration(
    errorMaxLines: 5,
    counterText: "",
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      borderSide: const BorderSide(color: AppColors.inactiveColor),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      borderSide: const BorderSide(color: AppColors.inactiveColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      borderSide: const BorderSide(color: AppColors.bodyTextColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    contentPadding: EdgeInsets.only(
        left: 24,
        bottom: AppDimensions.widgetPadding.h,
        top: AppDimensions.widgetPadding.h),
    hintText: hintText,
    labelText: isRequired ? "$levelText *" : levelText,
    floatingLabelStyle: const TextStyle(
      color: AppColors.bodyTextColor,
      fontWeight: FontWeight.bold,
    ),
    prefixIcon: preFix,
    suffixIcon: suffix,
    hintStyle: const TextStyle(color: AppColors.bodyTextColor, fontSize: 14),
    labelStyle: const TextStyle(color: AppColors.bodyTextColor, fontSize: 14),
  );
}

/*  ******Function to get http success status***** */
bool isHttpStatusSuccess(int statusCode) {
  if (kDebugMode) {
    print(statusCode);
  }

  return statusCode >= 200 && statusCode < 300;
}

/*  ******Function to generate http error message***** */
String generateHttpErrorMessage(int errorCode) {
  switch (errorCode) {
    case 400:
      return "400 Bad Request: The server cannot process the request due to a client error.";
    case 401:
      return "401 Unauthorized: The request has not been applied because it lacks valid authentication credentials for the target resource.";
    case 403:
      return "403 Forbidden: The server understood the request but refuses to authorize it.";
    case 404:
      return "404 Not Found: The server cannot find the requested resource.";
    case 405:
      return "405 Method Not Allowed: The method specified in the request is not allowed for the resource identified by the request.";
    case 406:
      return "406 Not Acceptable: The server cannot produce a response matching the list of acceptable values.";
    case 408:
      return "408 Request Timeout: The server did not receive a complete request message within the time that it was prepared to wait.";
    case 409:
      return "409 Conflict: The request could not be completed due to a conflict with the current state of the target resource.";
    case 410:
      return "410 Gone: The requested resource is no longer available and will not be available again.";
    case 500:
      return "500 Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request.";
    case 501:
      return "501 Not Implemented: The server does not support the functionality required to fulfill the request.";
    case 502:
      return "502 Bad Gateway: The server, while acting as a gateway or proxy, received an invalid response from an inbound server it accessed while attempting to fulfill the request.";
    case 503:
      return "503 Service Unavailable: The server is currently unable to handle the request due to temporary overloading or maintenance of the server.";
    case 504:
      return "504 Gateway Timeout: The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server it needed to access in order to complete the request.";
    case 505:
      return "505 HTTP Version Not Supported: The server does not support, or refuses to support, the HTTP protocol version that was used in the request message.";
    default:
      return "$errorCode: Unknown Error";
  }
}



/*  ******Function to calculate distance using Haversine formula***** */
String calculateDistance(LatLng start, LatLng end)
{
  final distanceInMeters = Geolocator.distanceBetween(
    start.latitude,
    start.longitude,
    end.latitude,
    end.longitude,
  );
  if (distanceInMeters < 1000) {
    return  "${distanceInMeters.toStringAsFixed(1)} m";
  }
  else {
    final distanceInKilometers = distanceInMeters / 1000;
    return "${distanceInKilometers.toStringAsFixed(1)} km";
  }
}


/*  ******Function to calculate distance using Haversine formula***** */
Future<double> calculateDistanceInMeter(LatLng destination)
async {
  var currentLocation = await getCurrentLocation();
  LatLng start = LatLng(currentLocation.latitude, currentLocation.longitude);


  return Geolocator.distanceBetween(
    start.latitude,
    start.longitude,
    destination.latitude,
    destination.longitude,
  );
}

/* ****Get current Location***** */


Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, return an error
    return Future.error('Location services are disabled.');
  }

  // Check for location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, return an error
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can retrieve the position
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );
}



Future<String?> distanceFromMyLocation(
    {required LatLng destination}) async {
  var currentLocation = await getCurrentLocation();
  LatLng start = LatLng(currentLocation.latitude, currentLocation.longitude);
  LatLng end =destination;
  return "${calculateDistance(start, end)} ";


}



Future<String> getImageAsBase64(CroppedFile imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}

String getTimeDifference(String futureTime) {
  // Parse the given future time string to a DateTime object
  DateTime futureDateTime = DateTime.parse(futureTime);

  // Get the current time
  DateTime now = DateTime.now();

  // Calculate the difference between the future time and the current time
  Duration difference = now.difference(futureDateTime);

  // Format the difference in a readable way
  String formattedDifference = formatDuration(difference);

  return formattedDifference;
}

String formatDuration(Duration duration) {
  int days = duration.inDays;
  int hours = duration.inHours.remainder(24);
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (days > 0) {
    return '$days days Ago';
  } else if (hours > 0) {
    return '$hours hours Ago';
  } else if (minutes > 0) {
    return '$minutes minutes Ago';
  } else {
    return '$seconds seconds Ago';
  }

}


String formatDateTime({required String dateTimeString}) {
  // Parse the given date-time string to a DateTime object
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format the DateTime object to the desired format
  DateFormat dateFormat = DateFormat("d MMM y, h:mm a");

  // Convert to the desired time zone (for example, Australia/Sydney)
  // You can change this to any other time zone if needed
  dateTime = dateTime.toLocal(); // Converts to local time zone

  String formattedDate = dateFormat.format(dateTime);

  // Add the desired time zone abbreviation
 // String timeZone = "(AU)"; // Australian time zone abbreviation

  return formattedDate;
}


List<String> generateBackwardYearList(int yearsBack) {
  int currentYear = DateTime.now().year;
  List<String> yearList = List<String>.generate(
      yearsBack + 1,
          (index) => (currentYear - index).toString()
  );
  return yearList;
}

String formatDecimalPoint({required String data, required int length}) {
  if (data.isEmpty) return data;

  double parsedDistance = double.tryParse(data) ?? 0.0;
  return parsedDistance.toStringAsFixed(1);
}

String formatWaitingTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours}h:${twoDigits(minutes)}m:${twoDigits(seconds)}s';
  } else if (minutes > 0) {
    return '${minutes}m:${twoDigits(seconds)}s';
  } else {
    return '${seconds}s';
  }
}
