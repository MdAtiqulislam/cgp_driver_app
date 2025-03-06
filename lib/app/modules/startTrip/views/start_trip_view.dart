import 'package:cgp_driver_app/app/modules/generalMap/general_map_controller.dart';
import 'package:cgp_driver_app/app/modules/startTrip/views/trip_client_info_card.dart';
import 'package:cgp_driver_app/app/modules/startTrip/views/trip_warehouse_info_card.dart';
import 'package:cgp_driver_app/common_widgets/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_switch.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../generalMap/geneal_map_widget.dart';
import '../controllers/start_trip_controller.dart';

class StartTripView extends GetView<StartTripController> {
  StartTripView({super.key});

  final mapController = Get.put(GeneralMapController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.status.value == TripStatus.completed,
      child: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Scaffold(
                appBar: CustomAppBar(
                  minimal: true,
                  title: "Trouble on Trip?",
                  titleTextSize: 14,
                  onTrouble: () {
                    Get.bottomSheet(
                      isScrollControlled: true,
                      ignoreSafeArea: false,
                      troubleOnTrip(),
                    );
                  },
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
                          showNavigationButton: true,
                          startNavigation: () {
                            Get.find<GeneralMapController>().openNavigationApps(
                                startPoint: controller.startPoint.value,
                                endPoint: controller.destinationPoint.value,
                                context: Get.context!);
                          }),
                      SizedBox(
                        height: AppDimensions.widgetPadding.h,
                      ),
                      controller.isClientMode.value
                          ? TripClientInfoCard(
                              isExpanded: controller.isExpand.value,
                              changeExpandMode: (value) {
                                controller.isExpand.value = value;
                              },
                              onTap: () {},
                              actionButtonText:
                                  controller.actionButtonText.value,
                            )
                          : TripWareHouseInfoCard(
                              onTap: () {
                                controller.controlButtonStatus();
                              },
                            ),
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

  Widget trailingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: AppDimensions.contentPadding.w,
        ),
        clientModeButton(),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            AppImagePath.callIcon,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            AppImagePath.messageIcon,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            AppImagePath.searchIcon,
            scale: 2,
          ),
        )
      ],
    );
  }

  Widget clientModeButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const BodyText(
          text: "Client Mode",
          color: AppColors.secondaryColor,
          size: 10,
        ),
        SizedBox(
          height: AppDimensions.contentPadding.h,
        ),
        CustomSwitch(
            value: controller.isClientMode.value,
            onChanged: (value) {
              controller.isClientMode.value = value;
            })
      ],
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
                      text:
                          "${controller.tripRequestDetails.value.data?.pickupLocation?.firstName ?? ""} ${controller.tripRequestDetails.value.data?.pickupLocation?.lastName ?? ""}"),
                  SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: controller.tripRequestDetails.value.data
                                ?.pickupLocation?.phoneNumber1 ??
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
                                  ?.pickupLocation?.phoneNumber1 ??
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
                      text:
                          "${controller.tripRequestDetails.value.data?.dropOffLocation?.firstName ?? ""} ${controller.tripRequestDetails.value.data?.dropOffLocation?.lastName ?? ""}"),
                  SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: controller.tripRequestDetails.value.data
                                ?.dropOffLocation?.phoneNumber1 ??
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
                                  ?.dropOffLocation?.phoneNumber1 ??
                              "",
                          color: AppColors.primaryColor,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.sectionPadding.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
