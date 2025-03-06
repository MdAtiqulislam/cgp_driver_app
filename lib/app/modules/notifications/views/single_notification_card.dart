import 'package:cgp_driver_app/app/modules/notifications/models/notifications_model.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class SingleNotificationCard extends StatelessWidget {
  final SingleNotificationModel notificationModel;
  final Function() onTap;
  const SingleNotificationCard({
    required this.notificationModel,
    required this.onTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
        padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.horizontalPadding.w,
            vertical: AppDimensions.contentPadding.h),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
            boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 10)]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(text: notificationModel.title ?? ""),
                  BodyText(text: notificationModel.message ?? ""),
                  BodyText(
                    text:
                        "Request from: ${notificationModel.data?.requestedByUserName ?? " "}",
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(
                    width: Get.width,
                      child: BodyText(text: formatDateTime(dateTimeString: notificationModel.createdAt.toString()),align: TextAlign.end,color: AppColors.primaryColor,))
                ],
              ),
            ),
            if (!(notificationModel.isRead ?? true))
              const Icon(
                Icons.circle,
                color: AppColors.successColor,
                size: 15,
              )
          ],
        ),
      ),
    );
  }
}
