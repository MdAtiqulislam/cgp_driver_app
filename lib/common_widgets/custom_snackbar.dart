import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';
import '../constraints/header_text.dart';

class CustomSnackBar {
  final String title;
  final String msg;
  final String buttonText;
  final bool showButton;
  final bool? isSuccess;
  final bool isWarning;
  final int? duration;
  VoidCallback? onTab;

  CustomSnackBar(
      {this.title = "",
      required this.msg,
      this.isSuccess,
      this.onTab,
      this.duration,
      this.showButton = false,
      this.buttonText = "",
      this.isWarning = false});

  SnackbarController showSnackBar() {
    final TextButton textButton = TextButton(
      onPressed: onTab,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          // margin: EdgeInsets.all(20),
          // height: 50,
          color: isWarning ? AppColors.successColor : AppColors.errorColor,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.h),
              child: HeaderText(
                text: buttonText,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ),
    );

    return showButton
        ? Get.snackbar(
            title.isNotEmpty
                ? title
                : isWarning
                    ? "Warning!"
                    : isSuccess!
                        ? "Success"
                        : "Alert",
            msg,
            mainButton: textButton,
            duration: Duration(seconds: duration ?? 3),
            backgroundColor: isWarning
                ? AppColors.warningColor
                : isSuccess!
                    ? Colors.green
                    : AppColors.errorColor,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.bounceInOut,
          )
        : Get.snackbar(
            title.isNotEmpty
                ? title
                : isWarning
                    ? "Warning!"
                    : isSuccess!
                        ? "Success"
                        : "Alert",
            msg,
            duration: Duration(seconds: duration ?? 3),
            backgroundColor: isWarning
                ? AppColors.warningColor
                : isSuccess!
                    ? AppColors.successColor
                    : AppColors.errorColor,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.fastOutSlowIn,
          );
  }
}
