import 'package:cgp_driver_app/common_widgets/custom_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/onbording_controller.dart';

class OnbordingView extends GetView<OnbordingController> {
  const OnbordingView({super.key});

  final String privacyPolicyUrl = "https://tradebar.com.au/privacy-policy/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? LoadingScreen()
              : Container(
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
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
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
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Deny: exit app or limited functionality
                                SystemNavigator.pop();
                              },
                              child: const Text("Deny"),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                controller.handelNext();
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
      ),
    );
  }
}
