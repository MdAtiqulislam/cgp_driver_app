import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/base_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_bottom_nav_bar.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../constraints/app_colors.dart';
import '../controllers/image_verification_controller.dart';

class ImageVerificationView extends GetView<ImageVerificationController> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      bottomNavBar: CustomBottomNavBar(content: AppButton(text: "Next",bgColor: AppColors.primaryColor,onTap: (){},),),
      body: Column(
        children: [
          const BodyText(text: "For security purpose please verify it’s you "),
          SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
              color: AppColors.inactiveColor,
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(
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
          HeaderText(text: "Please take a photo",color: AppColors.primaryColor,)
        ],
      ),
    );
  }
}
