import 'dart:io';

import 'package:cgp_driver_app/app/modules/customNavigation/controllers/custom_navigation_controller.dart';
import 'package:cgp_driver_app/app/modules/messaging/controllers/messaging_controller.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/views/trip_info_card.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
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

                  /* onTrouble: () {
                    Get.bottomSheet(
                      isScrollControlled: true,
                      ignoreSafeArea: false,
                      troubleOnTrip(),
                    );
                  },*/
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: Column(
                    children: [
                      /* StatusSection(
                        trailing: trailingSection(),
                      ),*/
                      /* if (mapBoxController.isNavigating.value)
                        SizedBox(
                          height: 0,
                          child: MapBoxNavigationView(
                            options: mapBoxController.options,
                            onRouteEvent: mapBoxController.onRouteEvent,
                            onCreated:
                                (MapBoxNavigationViewController controller) {
                              controller.initialize();
                            },
                          ),
                        ),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),*/
                      GeneralMapWidget(
                          showNavigationButton:
                              controller.showNavigationButton.value,
                          startNavigation: () async {
                            if (Platform.isIOS) {
                              controller.isLoading.value = true;
                              await getCurrentLocation().then((position) async {
                                await controller.initialize().then((value) {
                                  controller.isLoading.value = false;
                                });
                                var destinationLatitude =
                                    controller.destinationPoint.value.latitude;
                                var destinationLongitude =
                                    controller.destinationPoint.value.longitude;

                                var originLatitude = position.latitude;
                                var originLongitude = position.longitude;

                                final _startPoint = WayPoint(
                                    name: "Origin",
                                    latitude: originLatitude,
                                    longitude: originLongitude,
                                    isSilent: false);

                                final _endPoint = WayPoint(
                                    name: "Destination",
                                    latitude: destinationLatitude,
                                    longitude: destinationLongitude,
                                    isSilent: false);

                                var wayPoints = <WayPoint>[];
                                wayPoints.add(_startPoint);
                                wayPoints.add(_endPoint);
                                var opt = MapBoxOptions.from(
                                    controller.navigationOption);

                                opt.zoom = 14.0;
                                opt.mode =
                                    MapBoxNavigationMode.drivingWithTraffic;
                                opt.simulateRoute = false;
                                opt.enableRefresh = true;
                                opt.showEndOfRouteFeedback = false;
                                opt.showReportFeedbackButton = false;
                                opt.language = "en";
                                await MapBoxNavigation.instance.startNavigation(
                                    wayPoints: wayPoints, options: opt);

                                /*Navigator.of(context).push(
                                 MaterialPageRoute(
                                   builder: (context) =>
                                       EmbeddedNavigationScreen(
                                         destinationLatitude: controller
                                             .destinationPoint.value.latitude,
                                         destinationLongitude: controller
                                             .destinationPoint.value.longitude,
                                         originLatitude: position.latitude,
                                         originLongitude: position.longitude,
                                       ),
                                 ),
                               );*/
                              });
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
                          }),
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
