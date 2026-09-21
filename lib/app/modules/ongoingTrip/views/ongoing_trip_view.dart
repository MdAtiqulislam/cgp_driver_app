import 'dart:io';

import 'package:cgp_driver_app/app/modules/customNavigation/controllers/custom_navigation_controller.dart';
import 'package:cgp_driver_app/app/modules/messaging/controllers/messaging_controller.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/views/trip_info_card.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
//import 'package:flutter_mapbox_navigation_plus/flutter_mapbox_navigation_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_title.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../../utils/utils.dart';
import '../../generalMap/geneal_map_widget.dart';
import '../../startTrip/controllers/start_trip_controller.dart';
import '../controllers/ongoing_trip_controller.dart';

class OngoingTripView extends GetView<OngoingTripController> {
  final mapBoxController = Get.put(CustomNavigationController());

  OngoingTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.status.value == TripStatus.completed.name,
      child: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Scaffold(
                appBar: CustomAppBar(
                  minimal: true,
                  title: "Ongoing",
                  titleTextSize: 14,
                  enableBackButton: false,
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: Column(
                    children: [
                      GeneralMapWidget(
                          showNavigationButton:
                              controller.showNavigationButton.value,
                         startNavigation: () async {

                           /*Get.put(CustomNavigationController());
                           await Get.find<CustomNavigationController>()
                               .startNavigation(
                               controller
                                   .destinationPoint.value.latitude,
                               controller
                                   .destinationPoint.value.longitude)
                               .then((_) {
                             controller.isLoading.value = false;
                           });*/


                           if (Platform.isIOS) {
                             controller.isLoading.value = true;

                             final position = await getCurrentLocation();

                             await controller.initialize();
                             controller.isLoading.value = false;

                             final wayPoints = [
                               WayPoint(
                                 name: "Origin",
                                 latitude: position.latitude,
                                 longitude: position.longitude,
                                 isSilent: false,
                               ),
                               WayPoint(
                                 name: "Destination",
                                 latitude: controller.destinationPoint.value.latitude,
                                 longitude: controller.destinationPoint.value.longitude,
                                 isSilent: false,
                               ),
                             ];

                             var opt = MapBoxOptions.from(controller.navigationOption);

                             opt.zoom = 14.0;
                             opt.mode = MapBoxNavigationMode.drivingWithTraffic;
                             opt.simulateRoute = false;
                             opt.enableRefresh = true;
                             opt.showEndOfRouteFeedback = false;
                             opt.showReportFeedbackButton = false;
                             opt.language = "en-GB";
                             opt.units = VoiceUnits.metric;

                             /// 🔥 Important fixes
                            //  MapBoxNavigation.instance.getDefaultOptions();

                             //await MapBoxNavigation.instance.setDistanceUnit(VoiceUnits.metric);

                             await MapBoxNavigation.instance.startNavigation(
                               wayPoints: wayPoints,
                               options: opt,
                             );
                           }


                            else {
                              Get.put(CustomNavigationController());
                              await Get.find<CustomNavigationController>()
                                  .startNavigation(
                                      controller
                                          .destinationPoint.value.latitude,
                                      controller
                                          .destinationPoint.value.longitude)
                                  .then((_) {
                                controller.isLoading.value = false;
                              });
                            }



                          /* Get.put(CustomNavigationController());

                          await Get.find<CustomNavigationController>().startNavigation(
                             controller.destinationPoint.value.latitude,
                             controller.destinationPoint.value.longitude,
                           );
*/
                          }

                          ),
                      SizedBox(
                        height: AppDimensions.widgetPadding.h,
                      ),
                       TripInfoCard(),
                      SizedBox(
                        height: AppDimensions.widgetPadding.h,
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value) const LoadingScreen()
            ],
          ),
        ),
      ),
    );
  }

  Widget troubleOnTrip() {
    return SafeArea(
      child: Container(
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.contentPadding.h),
              width: Get.width,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const HeaderText(
                    text: "Trouble on trip?",
                    color: Colors.white,
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(AppImagePath.cancelIcon))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.verticalPadding.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomTitle(title: "Contact With Pickup Point"),
                  HeaderText(
                      text: controller.tripRequestDetails.value.data
                              ?.pickupLocation?.name ??
                          ""),
                  SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: controller.tripRequestDetails.value.data
                                ?.pickupLocation?.phone ??
                            "",
                      );
                      await launchUrl(launchUri);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(
                          width: AppDimensions.widgetPadding.w,
                        ),
                        HeaderText(
                          text: controller.tripRequestDetails.value.data
                                  ?.pickupLocation?.phone ??
                              "",
                          color: AppColors.primaryColor,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.sectionPadding.h,
                  ),
                  const CustomTitle(title: "Contact With Destination Point"),
                  HeaderText(
                      text: controller.tripRequestDetails.value.data
                              ?.dropOffLocation?.name ??
                          ""),
                  SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: controller.tripRequestDetails.value.data
                                ?.dropOffLocation?.phone ??
                            "",
                      );
                      await launchUrl(launchUri);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(
                          width: AppDimensions.widgetPadding.w,
                        ),
                        HeaderText(
                          text: controller.tripRequestDetails.value.data
                                  ?.dropOffLocation?.phone ??
                              "",
                          color: AppColors.primaryColor,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.sectionPadding.h,
                  ),
                  CustomTitle(
                      title:
                          "Live chat with ${controller.tripRequestDetails.value.data?.requestFrom?.name ?? ""}"),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {
                            Get.put(MessagingController());
                            Get.find<MessagingController>().initValue();
                            Get.find<MessagingController>().imageLink.value =
                                controller.tripRequestDetails.value.data
                                        ?.requestFrom?.url ??
                                    "";
                            Get.find<MessagingController>().chatWith.value =
                                controller.tripRequestDetails.value.data
                                        ?.requestFrom?.name ??
                                    "";
                            Get.find<MessagingController>().orderDetails.value =
                                controller.tripRequestDetails.value;
                            Get.find<MessagingController>()
                                .loadPreviousMessage();
                            Get.toNamed(Routes.MESSAGING);
                          },
                          icon: const Icon(Icons.chat,
                              size: 36, color: AppColors.primaryColor)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
