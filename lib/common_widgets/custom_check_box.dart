
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';

class CustomCheckBox extends StatelessWidget {
  final String? label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;
  final double contentPadding;
  final Widget? title;
  final CrossAxisAlignment? alignment;
  final EdgeInsets? margin;

  const CustomCheckBox({
    super.key,
     this.label,
    this.title,
    this.alignment,
    this.margin,
    required this.padding,
    this.contentPadding = AppDimensions.contentPadding,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        padding: padding,
        child: Row(
          crossAxisAlignment: alignment??CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 16,
                width: 16,
                margin: margin,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                        color: value
                            ? const Color(0xff0075B7)
                            : AppColors.secondaryColor,
                        width: 2)),
                child: value ? Image.asset(AppImagePath.checkIcon) : null),
            SizedBox(
              width: contentPadding.w,
            ),
           if(title!=null)Expanded(child: title??const Text("")),
           if(label!=null) Expanded(child: BodyText(text: label??"",fontWeight: FontWeight.w400,align: TextAlign.start,size: 14,)),
          ],
        ),
      ),
    );
  }
}
