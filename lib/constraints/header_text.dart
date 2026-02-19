import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final Color? color;
  final int maxLine;
  final double size;
  final double? lineHeight;
  final bool resizeable;
  final TextOverflow textOverflow;
  final FontWeight fontWeight;

  const HeaderText({
    super.key,
    required this.text,
    this.color = AppColors.headerTextColor, //const Color(0xFF626262),
    this.size = 16,
    this.textOverflow = TextOverflow.ellipsis,
    this.fontWeight = FontWeight.w600,
    this.align = TextAlign.start,
    this.resizeable = true,
    this.maxLine = 1,
    this.lineHeight
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
        fontSize:resizeable? size.sp:size,
        fontWeight: fontWeight,
        height: lineHeight
      ),
    );
  }
}
