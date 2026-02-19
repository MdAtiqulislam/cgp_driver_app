import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class BodyText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final Color? color;
  final double size;
  final bool resize;
  final int maxLine;
  final TextOverflow textOverflow;
  final FontWeight fontWeight;
  final double? lineHeight;

  const BodyText({
    super.key,
    required this.text,
    this.color =AppColors.bodyTextColor,// const Color(0xff4F4F4F),
    this.size=12,
    this.resize=true,
    this.textOverflow = TextOverflow.ellipsis,
    this.fontWeight = FontWeight.w400,
    this.align = TextAlign.start,
    this.maxLine = 3,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      overflow: textOverflow,
      textAlign: align,

      style: TextStyle(
        color: color,
        fontSize:resize? size.sp:size,
        fontWeight: fontWeight,
        height: lineHeight
      ),
    );
  }
}
