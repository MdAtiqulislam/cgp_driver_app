import 'package:cgp_driver_app/app/modules/customNavigation/controllers/custom_navigation_controller.dart';
import 'package:cgp_driver_app/app/modules/messaging/controllers/messaging_controller.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/views/trip_info_card.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
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
import '../../generalMap/geneal_map_widget.dart';
import '../../startTrip/controllers/start_trip_controller.dart';
import '../controllers/ongoing_trip_controller.dart';

class OngoingTripView extends GetView<OngoingTripController> {
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
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                      GeneralMapWidget(
                          showNavigationButton:
                              controller.showNavigationButton.value,
                          startNavigation: () {
                            Get.put(CustomNavigationController());

                            Get.find<CustomNavigationController>().startNavigation(
                                controller.destinationPoint.value.latitude,
                                controller.destinationPoint.value.longitude);
                            Get.toNamed(Routes.CUSTOM_NAVIGATION);
                            /* Get.find<MapController>().openNavigationApps(
                                startPoint: controller.startPoint.value,
                                endPoint: controller.destinationPoint.value,
                                context: Get.context!);*/
                          //  controller.openNavigationApps(context: context);
                          }),
                      SizedBox(
                        height: AppDimensions.widgetPadding.h,
                      ),
                      const TripInfoCard(),
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
                            Get.find<MessagingController>().chatWith.value=controller.tripRequestDetails.value.data
                                ?.requestFrom?.name ??
                                "";
                            Get.find<MessagingController>().orderDetails.value=controller.tripRequestDetails.value;
                            Get.find<MessagingController>().loadPreviousMessage();
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
