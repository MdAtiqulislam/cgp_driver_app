import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/base_screen.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../common_widgets/show_hide_password_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../controllers/password_controller.dart';

class PasswordView extends GetView<PasswordController> {
  PasswordView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseScreen(
        showLoading: controller.isLoading.value,
        bottomNavBar: CustomBottomNavBar(
          content: bottomNavBar()
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderText(
                text: "Set Password",
                size: 20,
                color: AppColors.bodyTextColor,
              ),
              SizedBox(
                height: AppDimensions.sectionPadding.h,
              ),
              CustomTextField(
                levelText: "New Password",
                hintText: "Password",
                isPassword: !controller.showPassword.value,
                isRequired: true,
                controller: controller.newPasswordController,
                validatorText: "required",
                suffix: ShowHidePasswordButton(
                  showPassword: controller.showPassword.value,
                  onTap: () {
                    controller.showPassword.value =
                        !controller.showPassword.value;
                  },
                ),
              ),
              SizedBox(
                height: AppDimensions.widgetPadding.h,
              ),
              CustomTextField(
                levelText: "Confirm Password",
                hintText: "Password",
                isPassword: !controller.showPassword.value,
                controller: controller.confirmPasswordController,
                validatorText: "required",
                isRequired: true,
                suffix: ShowHidePasswordButton(
                  showPassword: controller.showPassword.value,
                  onTap: () {
                    controller.showPassword.value =
                        !controller.showPassword.value;
                  },
                ),
              ),
              SizedBox(
                height: AppDimensions.sectionPadding.h,
              ),
              const BodyText(
                text:
                    "Your password must be 8 digits.\nMust Contain one Capital letter, one small letter, one number & one mark.",
                align: TextAlign.start,
              ),
              SizedBox(
                height: AppDimensions.sectionPadding * 3.h,
              ),
              AppButton(
                text: "Next",
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (controller.isRegistration.value) {
                      controller.setPassword();
                      // Get.offAllNamed(Routes.COMPLETE_REGISTRATION);
                    } else {
                      controller.reSetPassword();
                    }
                  }
                },
                bgColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget bottomNavBar() {
    return InkWell(
      onTap: (){
        Get.offAllNamed(Routes.SPLASH_SCREEN);
      },
      child: Row(
        children: [
          const Icon(Icons.house,color: AppColors.primaryColor,),
          SizedBox(
            width: AppDimensions.widgetPadding.w,
          ),
          const HeaderText(
            text: "Go to Home",
            color: AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}
