import 'package:cgp_driver_app/app/modules/statusSection/status_section_controller.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/custom_ratings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common_widgets/online_offline_toggle.dart';
import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/dimensions.dart';

class StatusSection extends StatelessWidget {
  final Widget? trailing;
  final bool showOnlineStatus;
  final String title;

  StatusSection(
      {this.trailing,
      this.showOnlineStatus = true,
      this.title = "Back to profile",
      super.key,});

  final controller = Get.put(StatusSectionController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const CircularProgressIndicator()
          : Column(
              children: [
                SizedBox(
                  height: AppDimensions.widgetPadding.h,
                ),
               if (!(controller.rider.value.isApproved ?? false))  Row(
                  children: [
                    Expanded(
                      child: BodyText(text:  "Your account is under review",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: controller.isActive.value
                            ? AppColors.primaryColor
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: AppDimensions.sectionPadding.w,
                    ),
                    InkWell(
                      onTap: (){
                       Get.toNamed(Routes.EDIT_PROFILE);
                      },
                      child: const BodyText(
                      text: "Edit Profile",//title,
                      align: TextAlign.end,
                      color: AppColors.primaryColor,
                    ),
                    )
                  ],
                ),
                if (!(controller.rider.value.isApproved ?? false)) SizedBox(
                  height: AppDimensions.sectionPadding.h,
                ),
                if (showOnlineStatus)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IgnorePointer(
                        ignoring: controller.loadingStatus.value||!(controller.rider.value.isApproved??false),
                        child: OnlineOfflineToggle(
                            isOnline: controller.isOnline.value,
                            onChanged: (value) {
                             // controller.isOnline.value = value;
                              controller.changeOnlineStatus(status:value);
                            }),
                      ),
                      SizedBox(width: AppDimensions.contentPadding.w,),
                      CustomRatingWidget(ratingValue: (controller.rider.value.avgRating?.averageRating??0).toDouble()),
                      Expanded(child: trailing ?? const SizedBox())
                    ],
                  ),
              ],
            ),
    );
  }
}
