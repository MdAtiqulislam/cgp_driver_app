import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  const CustomTitle({
    required this.title,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
         // mainAxisAlignment: MainAxisAlignment.center,
         // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(width: Get.width,),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(bottom: 6.sp),
                height: 1,
                color: AppColors.primaryColor,
              ),
            ),
            Container(
              color: Colors.white,
              child: BodyText(
                text: title,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
                align: TextAlign.start,
              ),
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),

          ],
        ),
        SizedBox(
          height: AppDimensions.widgetPadding.h,
        ),
      ],
    );
  }
}
