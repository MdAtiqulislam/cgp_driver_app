import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constraints/app_colors.dart';

class CustomProgressBarTheme {
  static ProgressIndicatorThemeData progressIndicatorTheme =
      const ProgressIndicatorThemeData(
        color: AppColors.primaryColor
      );

/*static  Pro appBarTheme=AppBarTheme(
  color: Colors.white,
  foregroundColor: AppColors.headerTextColor,
  iconTheme: const IconThemeData(color: AppColors.headerTextColor),
  elevation: 0,
  centerTitle: true,
  actionsIconTheme: const IconThemeData(color: Colors.white),
  shadowColor: Colors.transparent,
  titleTextStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,color: AppColors.headerTextColor),

);*/
}
