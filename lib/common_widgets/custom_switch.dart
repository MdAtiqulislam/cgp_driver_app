import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final Color? activeBorderColor;
  final Color? inactiveBorderColor;
  final Color? activeFillColor;
  final Color? inactiveFillColor;

  const CustomSwitch({
    required this.value,
    required this.onChanged,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.activeBorderColor,
    this.inactiveBorderColor,
    this.activeFillColor,
    this.inactiveFillColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 40.0,
        height: 15.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: value ? (activeBorderColor??AppColors.secondaryColor) : (inactiveBorderColor??AppColors.inactiveColor),
            width: 2.0,
          ),
          color: value ? (activeFillColor??AppColors.primaryColor.withOpacity(.2)) : (inactiveFillColor??Colors.grey.shade200),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              left: value ? 15.0 :-5,
              top: -10,
              bottom: -10,
              child: AnimatedContainer(
               /* width: value?25.0:8,
                height:value?25.0:8,
                */
                width: 25.0,
                height:25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value?(activeThumbColor??AppColors.primaryColor):(inactiveThumbColor??AppColors.placeholderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ), duration:  const Duration(milliseconds: 200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

