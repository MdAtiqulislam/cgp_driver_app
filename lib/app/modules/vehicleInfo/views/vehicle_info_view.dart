import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/base_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_drop_down_field.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_bottom_nav_bar.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../controllers/vehicle_info_controller.dart';

class VehicleInfoView extends GetView<VehicleInfoController> {
  VehicleInfoView({super.key});

  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showSlider: false,
      isCenter: false,
      bottomNavBar: CustomBottomNavBar(
        content: AppButton(
          text: "Next",
          bgColor: AppColors.primaryColor,
          onTap: () {
            if (!(_formKey.currentState?.validate() ?? false)) {
              //  controller.registration();
              Get.toNamed(Routes.DRIVING_LICENSE_INFO);
            }
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const HeaderText(text: "A few steps to go",
              size: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
              align: TextAlign.start,
            ),

            SizedBox(height: AppDimensions.sectionPadding.h,),
            CustomDropDownField(
                itemList: controller.vehicleTypeList,
                onChange: (value){},
              isRequired: true,
              hintText: "Vehicle Type",
              lavelText: "Vehicle Type",
              validatorText: "Required",
            ),
            SizedBox(height: AppDimensions.widgetPadding.h,),

            CustomTextField(
              levelText: "Capacity",
              hintText: "Capacity",
              isRequired: true,
              validatorText: "Required",
              controller: controller.capacityController,
            ),
            SizedBox(
              height: AppDimensions.widgetPadding.h,
            ),
            CustomTextField(
              levelText: "Vehicle registration number",
              hintText: "Vehicle registration number",
              isRequired: true,
              validatorText: "Required",
              controller: controller.vehicleRegistrationController,
            ),
            SizedBox(
              height: AppDimensions.widgetPadding.h,
            ),
            CustomTextField(
              levelText: "Tax token number",
              hintText: "Tax token number",
              isRequired: true,
              validatorText: "Required",
              controller: controller.vehicleTaxTokenController,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: AppDimensions.widgetPadding.h,
            ),
            CustomTextField(
              levelText: "Owner name",
              hintText: "Owner name",
              isRequired: true,
              validatorText: "Required",
              textInputType: TextInputType.phone,
              controller: controller.ownerNameController,
            ),
            SizedBox(
              height: AppDimensions.widgetPadding.h,
            ),
            CustomDropDownField(
              itemList: controller.licenseAuthorizedOfficeList,
              onChange: (value){},
              isRequired: true,
              hintText: "License authorized office",
              lavelText: "License authorized office",
              validatorText: "Required",
            ),
            SizedBox(
              height: AppDimensions.widgetPadding.h,
            ),
            const BodyText(
              text:
              "Asterisk * mark indicates must fill up areas. Please use valid information for verification & Safety purpose.",
              align: TextAlign.start,),
          ],
        ),
      ),
    );
  }
}
