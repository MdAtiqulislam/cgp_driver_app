import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/base_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_bottom_nav_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_drop_down_field.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/driver_info_controller.dart';

class DriverInfoView extends GetView<DriverInfoController> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        showSlider: false,
        isCenter: false,
        bottomNavBar: CustomBottomNavBar(content: AppButton(text: "Next",bgColor: AppColors.primaryColor,onTap: (){},),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 40,
                  color: AppColors.primaryColor,
                ),
                SizedBox(
                  width: AppDimensions.widgetPadding.w,
                ),
                Expanded(
                  child: HeaderText(
                    text: "Driving License Varified",
                    size: 20,
                    maxLine: 2,
                  ),
                )
              ],
            ),
            SizedBox(
              height: AppDimensions.sectionPadding.h,
            ),
            BodyText(
              text: "Final Steps to move forward",
              size: 16,
            ),
            SizedBox(
              height: AppDimensions.widgetPadding.h,
            ),
            Row(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadius.r),
                    color: AppColors.inactiveColor,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 45,
                        color: AppColors.placeholderColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.widgetPadding.w,),
                Expanded(child: HeaderText(text: "Upload your photo",color: AppColors.primaryColor,),)
              ],
            ),
            SizedBox(height: AppDimensions.sectionPadding.h,),
            CustomDropDownField(
              lavelText: "City you will drive in",
              hintText: "City you will drive in",
                isRequired: true,
                validatorText: "Required",
                itemList: controller.cityList,
                onChange: (value){}
            ),
            SizedBox(height: AppDimensions.sectionPadding.h,),
            CustomDropDownField(
              lavelText: "Destination range",
              hintText: "Destination range",
                isRequired: true,
                validatorText: "Required",
                itemList: controller.destinationRangeList,
                onChange: (value){}
            ),
            SizedBox(height: AppDimensions.sectionPadding.h,),
            CustomDropDownField(
              lavelText: "Schedule",
              hintText: "Schedule",
                isRequired: true,
                validatorText: "Required",
                itemList: controller.scheduleList,
                onChange: (value){}
            ),
          ],
        ),);
  }
}
