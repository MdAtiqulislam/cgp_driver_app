import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/dimensions.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Widget? content;

  const CustomBottomNavBar({this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding.w,
          vertical: AppDimensions.contentPadding.h),
      height: 70.h,
      child: content,
    );
  }
}
