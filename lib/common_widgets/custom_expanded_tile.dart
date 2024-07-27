import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';

class CustomExpandedTile extends StatelessWidget {
  final bool isExpanded;
  final Widget content;
  final int animationDuration;
  final String?title;
  final Function(bool)? onExpansionChange;

  const CustomExpandedTile({
    required this.isExpanded,
    required this.content,
    this.onExpansionChange,
    this.animationDuration=300,
    this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r)),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: isExpanded?const EdgeInsets.only(bottom: 10):null,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppDimensions.borderRadius.r),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 5,
                      offset: Offset(0, 2))
                ]),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: AppDimensions.horizontalPadding.w),
                    child: HeaderText(
                      text: title??"",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if(onExpansionChange!=null){
                      onExpansionChange!(!isExpanded);
                    }
                  },
                  icon: Icon(
                    isExpanded
                        ? Icons.expand_less_outlined
                        : Icons.expand_more_outlined,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: animationDuration),
            curve: Curves.easeInOut,
            child: Container(
              child: isExpanded
                  ? contentSection()
                  : Container(),
            ),
          )
        ],
      ),
    );
  }

Widget  contentSection() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding,
          vertical: AppDimensions.verticalPadding.h),
      width: Get.width,
      child: content,
    );
}
}
