import 'package:cgp_driver_app/app/modules/splashScreen/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_pages.dart';


class LocationDisclosureScreen extends GetView<SplashScreenController> {
  const LocationDisclosureScreen({super.key});

  final String privacyPolicyUrl = "https://tradebar.com.au/privacy-policy/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Icon(Icons.location_on, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "Background Location Required",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    "Our app collects location data to enable live driver tracking "
                        "even when the app is closed or not in use.\n\n"
                        "Location data is used to:\n"
                        "• Track trips in real-time\n"
                        "• Ensure driver and customer safety\n"
                        "• Improve delivery monitoring\n\n"
                        "Location data is securely transmitted to our server and is NOT shared with third parties.\n\n"
                        "By tapping 'Allow', you consent to background location access.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final Uri url = Uri.parse(privacyPolicyUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text(
                  "Read Privacy Policy",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Deny: exit app or limited functionality
                        Get.back(); // or SystemNavigator.pop();
                      },
                      child: const Text("Deny"),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Allow: request permissions & continue
                        Get.back();
                        await requestBackgroundLocation();
                        Get.toNamed(Routes.LOGIN);
                      },
                      child: const Text("Allow"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Use your existing requestBackgroundLocation() function
Future<void> requestBackgroundLocation() async {
  // Step 1: Foreground
  var whenInUse = await Permission.locationWhenInUse.status;
  if (!whenInUse.isGranted) {
    whenInUse = await Permission.locationWhenInUse.request();
    if (!whenInUse.isGranted) return;
  }

  // Step 2: Background
  var always = await Permission.locationAlways.status;
  if (!always.isGranted) {
    await Permission.locationAlways.request();
  }
}