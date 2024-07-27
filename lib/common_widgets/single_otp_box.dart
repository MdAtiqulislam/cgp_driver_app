import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constraints/app_colors.dart';


class SingleOTPBox extends StatelessWidget {
  final bool? isLast;
  final bool verified;
  final bool wrongOTP;
  final FocusNode? focusNode;
  // VoidCallback onCompleted(String);
  final void Function(String?) onCompleted;
  final TextEditingController? controller;

  const SingleOTPBox(
      {this.isLast,
      required this.onCompleted,
      this.controller,
        this.wrongOTP=false,
        this.verified=false,
        this.focusNode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.sp,
      height: 46.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
            color: verified?AppColors.primaryColor:wrongOTP?AppColors.errorColor:AppColors.borderColor,
            width: 2
        )
      ),
      child: Center(
        child: TextFormField(
         // scrollPadding: EdgeInsets.zero,
          focusNode: focusNode,
          enabled: !verified,
          controller: controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            if (value != "") {
              onCompleted(value);
              if (!(isLast ?? false)) {
                FocusScope.of(context).nextFocus();
              }
            } else {
              FocusScope.of(context).previousFocus();
            }
          },
          textAlign: TextAlign.center,
          style:  TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            border:InputBorder.none
            /*OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: AppColors.inactiveColor,width: 2),
            ),*/

          ),
        ),
      ),
    );
  }
}
