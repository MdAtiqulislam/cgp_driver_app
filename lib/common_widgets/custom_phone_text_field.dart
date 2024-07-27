import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text_field.dart';
class CustomPhoneTextField extends StatelessWidget {
 final String? levelText;
 final String? hintText;
 final TextEditingController? controller;
 final int? maxLength;


  const CustomPhoneTextField({super.key,
    this.levelText,
    this.hintText,
    this.controller,
    this.maxLength
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      levelText: levelText??"Phone",
      hintText: "Phone",
      isRequired: true,
      validatorText: "Required",
      textInputType: TextInputType.phone,
      maxLength: maxLength??8,
      preFix: Padding(
        padding:  EdgeInsets.only(top:15.h,bottom: 16.h,
        right: 2),
        child: const HeaderText(text: "04",align: TextAlign.end,size: 14,fontWeight: FontWeight.w700,),
      ),
      controller: controller,
    );
  }
}
