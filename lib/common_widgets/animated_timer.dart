import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedTimer extends StatefulWidget {
  final String time;
  final Color textColor;
  final double textSize;

  const AnimatedTimer({super.key, required this.time, required this.textColor, required this.textSize});

  @override
  _AnimatedTimerState createState() => _AnimatedTimerState();
}

class _AnimatedTimerState extends State<AnimatedTimer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.green,
    ).animate(_controller);

    _blurAnimation = Tween<double>(
      begin: 0,
      end: 25,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: _colorAnimation.value!.withOpacity(.4),
                blurRadius: _blurAnimation.value,
               // spreadRadius: 2,
              ),
              const BoxShadow(
                color: AppColors.shadowColor,
               blurRadius: 1
               // blurRadius: _blurAnimation.value,
               // spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w, vertical: AppDimensions.contentPadding.h),
          child: Text(
            widget.time,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
