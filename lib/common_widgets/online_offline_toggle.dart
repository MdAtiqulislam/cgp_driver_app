import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnlineOfflineToggle extends StatelessWidget {
  final bool isOnline;
  final Function(bool) onChanged;

  const OnlineOfflineToggle({super.key,

    required this.isOnline,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isOnline);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 140.0.w,
        height:MediaQuery.of(context).orientation==Orientation.landscape? 25.0.w:40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          color: isOnline ? AppColors.primaryColor : AppColors.inactiveColor,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
              left: isOnline ? 105.0.w : 5.0.w,
              top: -10,
              bottom: -10,
              child: Container(
                padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:isOnline? Colors.white:Colors.grey.shade300
                  ),
                  child: Image.asset(AppImagePath.deliveryVanOutline,height: 20.r,width: 20.r,)),
            ),
            Center(child: HeaderText(text: isOnline?"Online":"Offline",color:isOnline? Colors.white:Colors.grey.shade300,resizeable: true,size: 14,))
          ],
        ),
      ),
    );
  }
}
