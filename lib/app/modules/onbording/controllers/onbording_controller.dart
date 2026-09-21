import 'dart:io';

import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/custom_snackbar.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class OnbordingController extends GetxController {
  var isLoading=false.obs;

  @override
  void onInit() async{
    super.onInit();
   // await checkPermissionStatus();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> checkPermissionStatus() async {
    if(Platform.isIOS){
      Get.offAllNamed(Routes.SPLASH_SCREEN);
    }else{
      isLoading.value=true;
      LocalServices.getPermission().then((value){
        isLoading.value=false;
        if(value)Get.offAllNamed(Routes.SPLASH_SCREEN);
      });
    }
  }

  void handelNext() async{

    await requestBackgroundLocation().then((value) async {
      if(value){
        await LocalServices.setPermission(value);
        Get.offAllNamed(Routes.SPLASH_SCREEN);
      }else{
        CustomSnackBar(
          isSuccess: false,
          msg: "You need to give location permission first. Go to settings and give permission first to continue."
        ).showSnackBar();
      }
    });
  }

Future<bool> requestBackgroundLocation() async {
  // Step 1: Foreground permission
  var whenInUse = await Permission.locationWhenInUse.status;
  if (!whenInUse.isGranted) {
    whenInUse = await Permission.locationWhenInUse.request();
    if (!whenInUse.isGranted) {
      return false; // Foreground denied → cannot proceed
    }
  }

  // Step 2: Background permission
  var always = await Permission.locationAlways.status;
  if (!always.isGranted) {
    always = await Permission.locationAlways.request();
    if (!always.isGranted) {
      return false; // Background denied
    }
  }

  // Step 3: Permission granted
  return true;
}

}



/*
import 'dart:io';

import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/custom_snackbar.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnbordingController extends GetxController {
  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    Get.toNamed(Routes.SPLASH_SCREEN);

  }

  Future<void> checkPermissionStatus() async {
    if (Platform.isIOS) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
    } else {
      isLoading.value = true;

      bool hasPermission = await LocalServices.getPermission();

      isLoading.value = false;

      if (hasPermission) {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
      }
    }
  }

  /// 🔥 BUTTON CLICK
  void handelNext() async {
    bool granted = await requestLocationPermission();

    if (granted) {
      await LocalServices.setPermission(true);
      Get.offAllNamed(Routes.SPLASH_SCREEN);
    } else {
      CustomSnackBar(
        isSuccess: false,
        msg:
        "Please enable 'Allow all the time' location permission from settings to continue.",
      ).showSnackBar();
    }
  }

  /// 🔥 PROPER FLOW (PLAY STORE SAFE)
  Future<bool> requestLocationPermission() async {
    /// ✅ Step 1: Foreground Permission
    var whenInUse = await Permission.locationWhenInUse.status;

    if (!whenInUse.isGranted) {
      whenInUse = await Permission.locationWhenInUse.request();

      if (!whenInUse.isGranted) {
        return false;
      }
    }

    /// ✅ Step 2: Background Permission Check
    var always = await Permission.locationAlways.status;

    if (!always.isGranted) {
      /// ❗ Direct request না → Settings এ পাঠা
      await openAppSettings();
      return false;
    }

    return true;
  }
}*/
