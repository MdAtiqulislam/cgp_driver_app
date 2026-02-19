import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/body_text.dart';
import '../constraints/header_text.dart';

class CommonDescription extends StatelessWidget {
  final double fontSize;
  final double price;
  final String brand;
  final String size;
  final String material;
  final String weight;
  final double contentPadding;
  final double? lineHeight;

  const CommonDescription(
      {super.key,
      this.fontSize = 12,
      required this.size,
      required this.brand,
      required this.material,
      required this.price,
      required this.weight,
      this.contentPadding=100,
        this.lineHeight
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: contentPadding.w,
                child: HeaderText(
                  text: "Price:",
                  size: fontSize,
                  align: TextAlign.start,
                  lineHeight: lineHeight,
                ),),
            Expanded(
              child: BodyText(
                text: "$price\$",
                align: TextAlign.start,
                size: fontSize,
                lineHeight: lineHeight,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: contentPadding.w,
                child: HeaderText(
                  text: "Brand:",
                  size: fontSize,
                  align: TextAlign.start,
                  lineHeight: lineHeight,
                )),
            Expanded(
              child: BodyText(
                text: brand,
                align: TextAlign.start,
                size: fontSize,
                lineHeight: lineHeight,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: contentPadding.w,
              child: HeaderText(
                text: "Size:",
                size: fontSize,
                align: TextAlign.start,
                lineHeight: lineHeight,
              ),
            ),
            Expanded(
              child: BodyText(
                text: size,
                align: TextAlign.start,
                size: fontSize,
                lineHeight: lineHeight,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: contentPadding.w,
                child: HeaderText(
                  text: "Material:",
                  size: fontSize,
                  align: TextAlign.start,
                  lineHeight: lineHeight,
                ),),
            Expanded(
              child: BodyText(
                text: material,
                align: TextAlign.start,
                size: fontSize,
                lineHeight: lineHeight,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: contentPadding.w,
                child: HeaderText(
                  text: "Weight:",
                  size: fontSize,
                  align: TextAlign.start,
                  lineHeight: lineHeight,
                )),
            Expanded(
              child: BodyText(
                text: weight,
                align: TextAlign.start,
                size: fontSize,
                lineHeight: lineHeight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
