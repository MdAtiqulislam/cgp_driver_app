import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../constraints/header_text.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? splashColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool? showBorder;

  const AppButton(
      {super.key,
      this.fontWeight,
      this.fontSize,
      this.bgColor,
      this.splashColor,
      required this.text,
      required this.onTap,
      this.borderRadius,
      this.borderColor,
      this.textColor,
      this.height,
      this.horizontalPadding,
      this.verticalPadding,
      this.showBorder=false,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 25.r),
        ),
        border:(showBorder??true)
            ? Border.all(
            color: borderColor ?? AppColors.primaryColor, width: 1.5)
            :const Border(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: splashColor ??
              (bgColor == null ? AppColors.primaryColor : Colors.white54),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding ?? 10.0,
                vertical: verticalPadding ?? 10),
            child: Center(
              child: HeaderText(
                text: text,
                size: fontSize?.sp ?? 15,
                fontWeight: fontWeight ?? FontWeight.bold,
                color: textColor ??
                    (bgColor == null ? AppColors.primaryColor : Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
