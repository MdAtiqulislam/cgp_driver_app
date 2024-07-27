import 'package:cgp_driver_app/app/modules/tripRequest/controllers/trip_request_controller.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/custom_circle_avatar.dart';
import 'package:cgp_driver_app/common_widgets/custom_ratings.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WareHouseInfoCard extends GetView<TripRequestController> {
  // final bool isExpanded;
  final Function(bool) changeExpandMode;
  final Function() onAccepted;
  final Function() onDecline;

  const WareHouseInfoCard(
      {required this.onAccepted,
      // this.isExpanded = true,
      required this.changeExpandMode,
      super.key,
      required this.onDecline});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.isExpand.value = !controller.isExpand.value;
        },
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 5,
                    spreadRadius: 2)
              ]),
          child: Column(
            children: [
              Image.asset(
                controller.isExpand.value
                    ? AppImagePath.expandMoreIcon
                    : AppImagePath.expandLessIcon,
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.widgetPadding.w,
                    vertical: AppDimensions.contentPadding.h),
                child: controller.isExpand.value
                    ? Column(
                        children: [
                          wareHouseInfoSection(),
                          SizedBox(
                            height: AppDimensions.contentPadding.h,
                          ),
                          addressSection(),
                          SizedBox(
                            height: AppDimensions.contentPadding.h,
                          ),
                          const Divider(),
                          tripInfoSection(),
                          SizedBox(
                            height: AppDimensions.widgetPadding.h,
                          ),
                          buttonSection()
                        ],
                      )
                    : wareHouseInfoSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget wareHouseInfoSection() {
    return Row(
      children: [
         CustomCircleAvatar(width: 40, height: 40, image: controller.tripRequestDetails.value.data?.requestFrom?.url??""),
        SizedBox(
          width: AppDimensions.contentPadding.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderText(
                text: "Request For",
                size: 16,
                fontWeight: FontWeight.w500,
              ),
              HeaderText(
                text: controller
                        .tripRequestDetails.value.data?.requestFrom?.name ??
                    "",
                maxLine: 3,
                size: 16,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        Column(
          children: [
             CustomRatingWidget(ratingValue: (controller.tripRequestDetails.value.data?.requestFrom?.avgRating?.averageRating??0.0).toDouble(),alignment: CrossAxisAlignment.end,),
            FutureBuilder<String?>(
              future: distanceFromMyLocation(
                destination: LatLng(
                  controller.tripRequestDetails.value.data?.pickupLocation
                          ?.latitude ??
                      0.0,
                  controller.tripRequestDetails.value.data?.pickupLocation
                          ?.longitude ??
                      0.0,
                ),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const BodyText(text: "Calculating...", size: 10);
                } else if (snapshot.hasError) {
                  return BodyText(text: "Error: ${snapshot.error}", size: 10);
                } else if (snapshot.hasData) {
                  return BodyText(
                      text: "${snapshot.data ?? ""} away", size: 10);
                } else {
                  return const BodyText(text: "No location data", size: 10);
                }
              },
            )

            /*BodyText(
              text: "${distanceFromMyLocation(
                destination: LatLng(
                    controller.tripRequestDetails.value.data?.pickupLocation
                            ?.latitude ??
                        0.0,
                    controller.tripRequestDetails.value.data?.pickupLocation
                        ?.longitude ??
                        0.0),
              )}",
              size: 10,
            )*/
          ],
        )
      ],
    );
  }

  Widget addressSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderText(
                text: "Pickup Location",
                size: 12,
                color: AppColors.primaryColor,
              ),
              BodyText(
                text: controller
                        .tripRequestDetails.value.data?.pickupLocation?.name ??
                    "",
                color: AppColors.secondaryColor,
                size: 10,
              ),
              BodyText(
                text: controller.tripRequestDetails.value.data?.pickupLocation
                        ?.address ??
                    "",
                color: AppColors.secondaryColor,
                size: 10,
              )
            ],
          ),
        ),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: AppDimensions.widgetPadding.w),
          child: const Icon(
            Icons.arrow_forward_outlined,
            color: AppColors.primaryColor,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderText(
                text: "Drop Point",
                size: 12,
                color: AppColors.primaryColor,
              ),
              BodyText(
                text: controller
                        .tripRequestDetails.value.data?.dropOffLocation?.name ??
                    "",
                color: AppColors.secondaryColor,
                size: 10,
              ),
              BodyText(
                text: controller.tripRequestDetails.value.data?.dropOffLocation
                        ?.address ??
                    "",
                color: AppColors.secondaryColor,
                size: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tripInfoSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  const HeaderText(
                    text: "Total Distance:",
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  BodyText(
                    text: calculateDistance(
                      LatLng(
                          controller.tripRequestDetails.value.data
                                  ?.pickupLocation?.latitude ??
                              0.0,
                          controller.tripRequestDetails.value.data
                                  ?.pickupLocation?.longitude ??
                              0.0),
                      LatLng(
                          controller.tripRequestDetails.value.data
                                  ?.dropOffLocation?.latitude ??
                              0.0,
                          controller.tripRequestDetails.value.data
                                  ?.dropOffLocation?.longitude ??
                              0.0),
                    ),
                    color: AppColors.primaryColor,
                    size: 12,
                  ),
                ],
              ),
              Row(
                children: [
                  const HeaderText(
                    text: "Total Weight:",
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  BodyText(
                    text:
                        " ${controller.tripRequestDetails.value.data?.totalWeight ?? "0"} Tons",
                    color: AppColors.primaryColor,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const BodyText(text: "Trip Cost"),
            HeaderText(
              text:
                  "${controller.tripRequestDetails.value.data?.deliveryCost ?? "0"} AUD",
              size: 20,
              color: AppColors.primaryColor,
            )
          ],
        )
      ],
    );
  }

  Widget buttonSection() {
    return controller.tripRequestDetails.value.data?.assignedRider?.id == null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                text: "Accept",
                onTap: () {
                  onAccepted();
                },
                bgColor: AppColors.primaryColor,
                borderRadius: 10,
                horizontalPadding: AppDimensions.horizontalPadding * 2.w,
              ),
              AppButton(
                text: "Decline",
                onTap: () {
                  onDecline();
                },
                bgColor: AppColors.errorColor,
                borderRadius: 10,
                horizontalPadding: AppDimensions.horizontalPadding * 2.w,
              )
            ],
          )
        : Column(
            children: [
              const HeaderText(
                text: "This request is not available any more.",
                color: AppColors.primaryColor,
                align: TextAlign.start,
                size: 12,
              ),
              AppButton(
                  text: "Back to home",
                  bgColor: AppColors.primaryColor,
                  onTap: () {
                    Get.offAndToNamed(Routes.HOME);
                  })
            ],
          );
  }
}
