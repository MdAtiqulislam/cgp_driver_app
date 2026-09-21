import 'package:cgp_driver_app/common_widgets/base_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_bottom_nav_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_text_field.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/show_hide_password_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseScreen(
        showLoading: controller.isLoading.value,
        bottomNavBar: CustomBottomNavBar(content: bottomNavBar()),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const HeaderText(
                text: "Log in to your Account",
                size: 20,
                color: AppColors.bodyTextColor,),
                  SizedBox(
                height: AppDimensions.sectionPadding.h,
                  ),
                  CustomTextField(
                levelText: "Phone/ Email",
                hintText: "Phone/ Email",
                isRequired: true,
                validatorText: "Required",
                textInputType: TextInputType.emailAddress,
                controller: controller.emailController,
              ),
              const BodyText(text: "Phone number: 0412345678"),
              SizedBox(
                height: AppDimensions.widgetPadding.h,
              ),
              CustomTextField(
                levelText: "Password",
                hintText: "Password",
                isPassword: !controller.showPassword.value,
                isRequired: true,
                validatorText: "required",
                controller: controller.passwordController,
                suffix: ShowHidePasswordButton(
                  showPassword: controller.showPassword.value,
                  onTap: () {
                    controller.showPassword.value =
                        !controller.showPassword.value;
                  },
                ),
              ),
              SizedBox(height: AppDimensions.widgetPadding.h),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.FORGOT_PASSWORD);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.contentPadding.h,
                      horizontal: 5.w),
                  child: const BodyText(
                    text: "Forgot Password?",
                    size: 12,
                  ),
                ),
              ),
              SizedBox(
                height: AppDimensions.sectionPadding * 3.h,
              ),
              AppButton(
                text: "Next",
                onTap: () {
                  if ((_formKey.currentState?.validate() ?? false)) {
                    controller.login();
                 //  showLocationDisclosure();
                    //  Get.toNamed(Routes.IMAGE_VERIFICATION);
                  }
                },
                bgColor: AppColors.primaryColor,
                showBorder: false,
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget bottomNavBar() {
    return Row(
      children: [
        const BodyText(text: "Don't have an account? "),
        SizedBox(
          width: AppDimensions.widgetPadding.w,
        ),
        InkWell(
          onTap: () {
            Get.offAndToNamed(Routes.REGISTRATION);
          },
          child: const HeaderText(
            text: "Register",
            color: AppColors.primaryColor,
          ),
        )
      ],
    );
  }

/*  void showLocationDisclosure() {
    Get.dialog(
      AlertDialog(
        title: const Text("Background Location Required"),
        content: const SingleChildScrollView(
          child: Text(
              "This app collects location data to enable live driver tracking "
                  "even when the app is closed or not in use.\n\n"
                  "Location data is used to:\n"
                  "• Track trips in real-time\n"
                  "• Ensure customer safety\n"
                  "• Improve delivery monitoring\n\n"
                  "Location data is securely transmitted to our server and is not shared with third parties.\n\n"
                  "By tapping 'Allow', you consent to background location access."
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text("Deny"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              //await Get.find<SplashScreenController>().requestLocationPermission();
              controller.login();
            },
            child: const Text("Allow"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }*/


}
