import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/base_screen.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../routes/app_pages.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        body: Obx(
      () => controller.isLoading.value
          ? const LoadingScreen()
          : SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(children: [

                AppButton(
                  text: "Create Account",
                  onTap: () {
                    Get.toNamed(Routes.REGISTRATION);
                  //  Get.toNamed(Routes.SERVICE_TYPE);
                  },
                  bgColor: AppColors.primaryColor,
                  showBorder: false,
                ),
                SizedBox(
                  height: AppDimensions.sectionPadding.h,
                ),
                const BodyText(
                  text: "Already have an account?",
                ),
                SizedBox(
                  height: AppDimensions.widgetPadding.h,
                ),
                AppButton(
                  text: "Login",
                  onTap: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                  bgColor: AppColors.primaryColor,
                ),
                SizedBox(
                  height: AppDimensions.sectionPadding.h,
                ),
              ]),
            ),
    ));
  }
}
