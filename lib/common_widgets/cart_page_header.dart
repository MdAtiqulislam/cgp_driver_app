import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';

class CartPageHeader extends StatelessWidget {
  final String? trailingText;
  final String? image;
  final String title;

  const CartPageHeader({
    super.key,
    this.trailingText,
    this.title="Your Cart",
    this.image
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppDimensions.contentPadding.h,
        ),
        Row(
          children: [
            Image.asset(
              image?? AppImagePath.shoppingCartBlack,
              height: 20.sp,
              width: 23.sp,
            ),
            SizedBox(
              width: AppDimensions.widgetPadding.w,
            ),
             HeaderText(
              text: title,
              size: 20,
            ),
            Expanded(
              child: BodyText(
                text: trailingText ?? "",
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                align: TextAlign.end,
              ),
            )
          ],
        ),
      ],
    );
  }
}
