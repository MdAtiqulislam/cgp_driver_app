import 'package:cgp_driver_app/app/modules/generalMap/general_map_controller.dart';
import 'package:cgp_driver_app/app/modules/startTrip/controllers/start_trip_controller.dart';
import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/custom_circle_avatar.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TripWareHouseInfoCard extends GetView<StartTripController> {
  // final bool isExpanded;
  // final String actionButtonText;
  final Function() onTap;
  final mapController = Get.put(GeneralMapController());

  TripWareHouseInfoCard(
      {
      //   required this.actionButtonText,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowColor, blurRadius: 5, spreadRadius: 2)
            ]),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                controller.isExpand.value = !controller.isExpand.value;
                //onTap(!isExpanded);
              },
              child: Image.asset(
                controller.isExpand.value
                    ? AppImagePath.expandMoreIcon
                    : AppImagePath.expandLessIcon,
                height: 10,
              ),
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
                        const Divider(),
                       // notificationSection(),
                        tripStatusSection(),
                        locationSection(),
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
    );
  }

  Widget wareHouseInfoSection() {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.isExpand.value = !controller.isExpand.value;
        },
        child: Row(
          children: [
            const CustomCircleAvatar(
              width: 40,
              height: 40,
              image: "",
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),
            Expanded(
              child: HeaderText(
                text:
                    "Trip for ${controller.tripRequestDetails.value.data?.requestFrom?.name ?? ""}",
                maxLine: 3,
                size: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: AppColors.successColor,
                  size: 10,
                ),
                SizedBox(
                  width: AppDimensions.contentPadding.w,
                ),
                const BodyText(
                  text: "Ongoing",
                  color: AppColors.primaryColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget buttonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Obx(
            () => IgnorePointer(
              ignoring: false, //!controller.isButtonEnabled.value,
              child: AppButton(
                text: controller.actionButtonText.value,
                onTap: () {
                  controller.buttonAction();
                  // onTap();
                },
                bgColor: controller.buttonColor.value,
                borderRadius: 10,
                horizontalPadding: AppDimensions.horizontalPadding * 2.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget tripStatusSection() {
    return Row(
      children: [
        Image.asset(
          AppImagePath.navigationIcon,
          scale: 1.5,
        ),
        SizedBox(
          width: AppDimensions.contentPadding.w,
        ),
        HeaderText(
          text: "Moving to ${controller.destinationPointName.value} location",
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }
  Widget locationSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderText(
                text: "Pickup Location",
                size: 12,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
              BodyText(
                  text: controller.tripRequestDetails.value.data?.pickupLocation
                          ?.address ??
                      ""),
            ],
          ),
        ),
        SizedBox(
          width: AppDimensions.sectionPadding.w,
        ),
        Flexible(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.timer,
                    size: 15,
                  ),
                  SizedBox(
                    width: AppDimensions.sectionPadding.w,
                  ),
                  HeaderText(
                      text: controller.tripRequestDetails.value.data
                              ?.estimatedArrivalTime ??
                          "0")
                ],
              ),*/
              showDistance(),
            ],
          ),
        )
      ],
    );
  }
  showDistance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.golf_course_rounded,
          size: 15,
        ),
        HeaderText(text: "${controller.pickupDistance.value} away")
      ],
    );
  }
}
