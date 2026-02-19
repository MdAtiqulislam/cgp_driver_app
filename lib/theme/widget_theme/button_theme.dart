
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';

class CustomButtonTheme{

  static  ButtonThemeData buttonTheme=ButtonThemeData(
    buttonColor: AppColors.primaryColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r))
  );

}