import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/base_screen.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value || controller.token.value.isNotEmpty
          ? loadingScreen()
          : BaseScreen(
              body: SingleChildScrollView(
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
            ),
    );
  }

  Widget loadingScreen() {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          minimal: true,
        ),
        body: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeaderText(
                text: "Welcome to TradeBar",
                color: AppColors.primaryColor,
                size: 20,
                align: TextAlign.start,
              ),
              SizedBox(
                height: AppDimensions.sectionPadding.h * 2,
              ),
              Container(
                  width: 200.sp,
                  height: 200.sp,
                  margin: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(AppImagePath.appIcon)),
            ],
          ),
        ),
      ),
    );
  }
}
