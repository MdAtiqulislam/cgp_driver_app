import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/base_screen.dart';
import '../../../../common_widgets/custom_bottom_nav_bar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
   ForgotPasswordView({super.key});
  final GlobalKey<FormState>_formKey=GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>BaseScreen(
      showLoading: controller.isLoading.value,
      bottomNavBar: CustomBottomNavBar(
        content: bottomNavBar(),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderText(
              text: "Enter your Email address",
              size: 20,
              color: AppColors.bodyTextColor,
              align: TextAlign.start,
            ),
            SizedBox(
              height: AppDimensions.sectionPadding.h,
            ),
            CustomTextField(
              levelText: "Email",
              hintText: "Type Email address",
              isRequired: true,
              controller: controller.emailController,
              validatorText: "required",
            ),
            SizedBox(
              height: AppDimensions.sectionPadding.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: BodyText(
                text:
                "We will send a six digit OTP to your Email.\nPlease type the OTP to reset your password",
                align: TextAlign.start,
              ),
            ),
            SizedBox(
              height: AppDimensions.sectionPadding * 2.h,
            ),
            AppButton(
              text: "Next",
              onTap: () {
                if(_formKey.currentState?.validate()??false){
                  controller.getOtp();
                }
              },
              bgColor: AppColors.primaryColor,
            )
          ],
        ),
      ),
    ),);
  }
   Widget bottomNavBar() {
     return InkWell(
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
     );
   }
}
