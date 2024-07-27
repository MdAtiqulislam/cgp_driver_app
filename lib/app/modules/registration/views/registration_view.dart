import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/base_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_bottom_nav_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_loading_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_phone_text_field.dart';
import 'package:cgp_driver_app/common_widgets/custom_text_field.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';
import '../controllers/registration_controller.dart';

class RegistrationView extends GetView<RegistrationController> {
  RegistrationView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          BaseScreen(
            showSlider: false,
            bottomNavBar: CustomBottomNavBar(
              content: bottomNavBar(),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    levelText: "First Name",
                    hintText: "First Name",
                    isRequired: true,
                    validatorText: "Required",
                    controller: controller.firstNameController,
                  ),
                  SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                  CustomTextField(
                    levelText: "Last Name",
                    hintText: "Last Name",
                    isRequired: true,
                    validatorText: "Required",
                    controller: controller.lastNameController,
                  ),
                  /* SizedBox(
                  height: AppDimensions.widgetPadding.h,
                ),
                CustomDropDownField(
                    itemList: controller.genders,
                    lavelText: "Gender",
                    hintText: "Gender",
                    isRequired: true,
                    validatorText: "Required",
                    onChange: (value) {
                      controller.selectedGender = value ?? "";
                    }),*/
                  SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                  CustomTextField(
                    levelText: "Email",
                    hintText: "Email",
                    isRequired: true,
                    validatorText: "Required",
                    controller: controller.emailController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                  CustomPhoneTextField(
                    controller: controller.phoneController,
                    maxLength: 8,
                  ),

                  /*CustomTextField(
                    levelText: "Phone",
                    hintText: "Phone",
                    isRequired: true,
                    validatorText: "Required",
                    textInputType: TextInputType.phone,
                    preFix: Padding(
                      padding:  EdgeInsets.only(top:15.h,bottom: 16.h ),
                      child: BodyText(text: "04",align: TextAlign.end,size: 14,fontWeight: FontWeight.w700,),
                    ),
                    controller: controller.phoneController,
                  ),*/
                  SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                  const BodyText(
                    text:
                        "Asterisk * mark indicates must fill up areas. Please use valid information for verification & Safety purpose.",
                    align: TextAlign.start,
                  ),

                  SizedBox(height: AppDimensions.sectionPadding.h,),
                  AppButton(
                    text: "Next",
                    bgColor: AppColors.primaryColor,
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.registration();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          if (controller.isLoading.value) const LoadingScreen()
        ],
      ),
    );
  }

  Widget bottomNavBar() {
    return Row(
      children: [
        const BodyText(text: "Already have an account? "),
        SizedBox(
          width: AppDimensions.widgetPadding.w,
        ),
        InkWell(
          onTap: (){
            Get.offAndToNamed(Routes.LOGIN);
          },
          child: const HeaderText(
            text: "Login",
            color: AppColors.primaryColor,
          ),
        )
      ],
    );
  }
}
