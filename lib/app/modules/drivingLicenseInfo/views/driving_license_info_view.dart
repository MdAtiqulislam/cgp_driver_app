import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/base_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_bottom_nav_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_text_field.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/driving_license_info_controller.dart';

class DrivingLicenseInfoView extends GetView<DrivingLicenseInfoController> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showSlider: false,
      isCenter: false,
      bottomNavBar: CustomBottomNavBar(
        content: AppButton(
          text: "NEXT",
          bgColor: AppColors.primaryColor,
          onTap: () {
            Get.toNamed(Routes.DRIVER_INFO);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderText(
            text: "Congratulations!",
            size: 20,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: AppDimensions.widgetPadding.h,
          ),
          BodyText(
            text: "Your vehicle is registered & enlisted to our database",
            size: 16,
            align: TextAlign.start,
          ),
          SizedBox(
            height: AppDimensions.sectionPadding * 2.h,
          ),
          const HeaderText(
            text: "We need your driving license detail to finalize the account",
            maxLine: 5,
            color: AppColors.primaryColor,
            size: 14,
            fontWeight: FontWeight.w600,
            align: TextAlign.start,
          ),
          SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          CustomTextField(
            levelText: "Driving License Number",
            hintText: "Driving License Number",
            isRequired: true,
            validatorText: "Required",
          ),
          SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          Container(
            height: 200,
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.inactiveColor,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
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
          SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          BodyText(
            text:
                "Please take a photo of your driving license. Please make sure the light & sharpness is good",
            maxLine: 5,
          )
        ],
      ),
    );
  }
}
