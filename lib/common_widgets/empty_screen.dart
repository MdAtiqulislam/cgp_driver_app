
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_strings.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
class EmptyScreen extends StatelessWidget {
  final double? height;
  final double? width;
  final String title;
  final String? imagePath;
  final double? imageScaleFactor;

  const EmptyScreen({super.key,
   this.height,
   this.width,
    this.imagePath,
    this.imageScaleFactor,
  required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width??Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Image.asset(imagePath??AppImagePath.emptyIcon,scale: imageScaleFactor,),
          SizedBox(height: AppDimensions.sectionPadding.h,),
          BodyText(text: title,size: 14,fontWeight: FontWeight.w600,)
      ],),
    );
  }
}
