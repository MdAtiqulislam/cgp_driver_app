
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';
import '../constraints/dimensions.dart';

class CustomSearchBar extends StatelessWidget {
  final double? radius;
  final TextEditingController? searchController;
  final bool enabled;
  final bool focus;
  final Function(String?)? onChange;
  final Function(String?)? onSubmit;
  final Function()?onTap;

  const CustomSearchBar({
    this.searchController,
    this.onChange,
    this.onSubmit,
    this.enabled=true,
    this.focus=true,
    this.onTap,
    this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 45.r),
            color: const Color(0xFFE8E8E8)),
        child: TextFormField(
          enabled: enabled,
          autofocus: focus,
          controller: searchController,
          onChanged: onChange,
          onFieldSubmitted: onSubmit,
          style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: AppColors.bodyTextColor),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding.w,
                vertical: AppDimensions.widgetPadding.h
            ),
            border: InputBorder.none,
            hintText: "what are you looking for",
            hintStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.hintTextColor),
            suffixIcon: Padding(
              padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
              child: IconButton(
                onPressed: (){},
                icon: Image.asset("assets/icons/search_icon.png"),
              ),
            )
          ),
        ),
      ),
    );
  }
}
