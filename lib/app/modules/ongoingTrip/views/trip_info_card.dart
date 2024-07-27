import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/animated_timer.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_circle_avatar.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';

class TripInfoCard extends GetView<OngoingTripController> {
  const TripInfoCard({super.key});

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
                        Divider(),
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
             CustomCircleAvatar(
              width: 40,
              height: 40,
              image: controller.tripRequestDetails.value.data?.requestFrom?.url??"",
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
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: AppColors.successColor,
                    size: 10,
                  ),
                  SizedBox(
                    width: AppDimensions.contentPadding.w,
                  ),
                  BodyText(
                    text: "Ongoing",
                    color: AppColors.primaryColor,
                  )
                ],
              ),
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
                  controller.changeOrderStatus();
                  // onTap();
                },
                bgColor: AppColors.primaryColor,
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
        const Icon(
          Icons.interests,
          color: AppColors.primaryColor,
        )
        /* Image.asset(
          AppImagePath.navigationIcon,
          scale: 1.5,
        )*/
        ,
        SizedBox(
          width: AppDimensions.contentPadding.w,
        ),
        HeaderText(
          text: controller.statusText.value,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget locationSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       if(controller.showLocation.value=="pickup") Flexible(
          //  flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
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
       if(controller.showLocation.value=="destination") Flexible(
          //  flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
                text: "Destination Location",
                size: 12,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
              BodyText(
                  text: controller.tripRequestDetails.value.data?.dropOffLocation
                          ?.address ??
                      ""),
            ],
          ),
        ),
        SizedBox(
          width: AppDimensions.widgetPadding.w,
        ),
        Flexible(
          // flex: 4,
          child: showDistance(),
        )
      ],
    );
  }

  showDistance() {
    return controller.showTimer.value
        ?AnimatedTimer(
      time: controller.elapsedTime.value,
      textColor: AppColors.primaryColor,
      textSize: 20,
    )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.golf_course_rounded,
                size: 15,
              ),
              Expanded(
                  child: HeaderText(text: "${controller.distance.value} away"))
            ],
          );
  }
}
