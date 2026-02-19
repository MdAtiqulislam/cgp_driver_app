
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';
import '../constraints/dimensions.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final Color headerColor;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.headerColor = AppColors.primaryColor // Default header color
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration:  BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.borderRadius.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.contentPadding.h),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.borderRadius.r),),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Get.textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomBottomSheet({
  required String title,
  required Widget content,
  Color? headerColor , // Default header color
}) {
  Get.bottomSheet(
    CustomBottomSheet(
      title: title,
      content: content,
      headerColor: headerColor??AppColors.primaryColor,
    ),
    ignoreSafeArea: false,
    isScrollControlled: true, // Allows the bottom sheet to take full height if needed
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    backgroundColor: Colors.transparent, // Ensure background color of the sheet is transparent
  );
}
