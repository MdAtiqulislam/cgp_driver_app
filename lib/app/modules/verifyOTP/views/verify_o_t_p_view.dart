import 'package:cgp_driver_app/common_widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/base_screen.dart';
import '../../../../common_widgets/single_otp_box.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../controllers/verify_o_t_p_controller.dart';

class VerifyOTPView extends GetView<VerifyOTPController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseScreen(
        showLoading: controller.isLoading.value,
        showSlider: false,
        bottomNavBar: CustomBottomNavBar(
          content: bottomNavBar(),
        ),
        body: SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              otpSection(),
              if (controller.wrongOTP.value)
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.widgetPadding.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BodyText(
                        text: "OTP doesn’t match.",
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppDimensions.contentPadding.h),
                          child: const BodyText(
                              text: "Try with different account?"),
                        ),
                      )
                    ],
                  ),
                ),
              SizedBox(
                height: AppDimensions.sectionPadding.h,
              ),
              resendOTPSection(),
              SizedBox(
                height: AppDimensions.sectionPadding * 3.h,
              ),
              IgnorePointer(
                ignoring: !controller.isValidate.value,
                child: AppButton(
                  text: "Next",
                  onTap: () {
                    controller.handelNext();
                  },
                  bgColor: controller.isValidate.value
                      ? AppColors.primaryColor
                      : AppColors.inactiveColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  otpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderText(
          text: "Enter your 6 digit code we’ve sent to your email",
          size: 14,
          fontWeight: FontWeight.w600,
          align: TextAlign.start,
        ),
        SizedBox(
          height: AppDimensions.contentPadding.h,
        ),
        BodyText(
          text: controller.email.value,
          size: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.inactiveColor,
        ),
        SizedBox(
          height: AppDimensions.sectionPadding.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SingleOTPBox(
              verified: controller.isValidate.value,
              wrongOTP: controller.wrongOTP.value,
              controller: controller.c1,
              focusNode: controller.focusNode,
              onCompleted: (value) {
                controller.checkOtpLength(value);
              },
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),
            SingleOTPBox(
              verified: controller.isValidate.value,
              wrongOTP: controller.wrongOTP.value,
              controller: controller.c2,
              onCompleted: (value) {
                controller.checkOtpLength(value);
              },
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),
            SingleOTPBox(
              verified: controller.isValidate.value,
              wrongOTP: controller.wrongOTP.value,
              controller: controller.c3,
              onCompleted: (value) {
                controller.checkOtpLength(value);
              },
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),
            SingleOTPBox(
              verified: controller.isValidate.value,
              wrongOTP: controller.wrongOTP.value,
              controller: controller.c4,
              onCompleted: (value) {
                controller.checkOtpLength(value);
              },
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),
            SingleOTPBox(
              verified: controller.isValidate.value,
              wrongOTP: controller.wrongOTP.value,
              controller: controller.c5,
              onCompleted: (value) {
                controller.checkOtpLength(value);
              },
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),
            SingleOTPBox(
              verified: controller.isValidate.value,
              wrongOTP: controller.wrongOTP.value,
              controller: controller.c6,
              onCompleted: (value) {
                if (value!.length == 1) {
                  controller.verifyOTP();
                }
                controller.checkOtpLength(value);
              },
              isLast: true,
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),
          ],
        ),
      ],
    );
  }

  resendOTPSection() {
    return controller.isValidate.value
        ? Center(
            child: Padding(
              padding: EdgeInsets.only(top: AppDimensions.sectionPadding.h),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryColor,
                size: 46.sp,
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText(text: "Didn’t receive the code?"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyText(text: "You can request a new code after the time"),

                  if (controller.resendOtpTime.value > 0)
                    BodyText(
                      text:
                          "${controller.resendOtpTime.value ~/ 60} min: ${controller.resendOtpTime.value % 60} Sec",
                      color: AppColors.primaryColor,
                      size: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  if (controller.resendOtpTime.value <= 0)
                    InkWell(
                      splashColor: Colors.white54,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, // AppDimensions.horizontalPadding,
                            vertical: 3.h),
                        child: const HeaderText(
                          text: "Resend Code",
                          color: AppColors.primaryColor,
                          size: 12,
                        ),
                      ),
                      onTap: () {
                        controller.resendOTP();
                      },
                    ),

                  //    BodyText(text: "00:30 Sec",fontWeight: FontWeight.w500,color: AppColors.primaryColor,),
                ],
              )
            ],
          );
  }

  Widget bottomNavBar() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding.w,
          vertical: AppDimensions.verticalPadding.h),
      child: InkWell(
        onTap: (){
          Get.back();
        },
        child: Row(
          children: [
            const Icon(Icons.arrow_back,color: AppColors.primaryColor,),
            SizedBox(
              width: AppDimensions.widgetPadding.w,
            ),
            HeaderText(
              text: "Back",
              color: AppColors.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
