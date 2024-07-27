import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AnimatedButtonWithProgress extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color startColor;
  final Color endColor;
  final Duration duration;
  final Widget icon;

  const AnimatedButtonWithProgress({
    required this.onPressed,
    required this.text,
    required this.startColor,
    required this.endColor,
    required this.duration,
    required this.icon,
    super.key,
  });

  @override
  _AnimatedButtonWithProgressState createState() =>
      _AnimatedButtonWithProgressState();
}

class _AnimatedButtonWithProgressState extends State<AnimatedButtonWithProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();

    _widthAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onPressed();
      },
      child: Stack(
        children: [
          MaterialButton(
            clipBehavior: Clip.hardEdge,
            height: 48,
            color: AppColors.primaryColor,
            onPressed: (){
              widget.onPressed();
            },child:Row(
            children: [
              widget.icon,
              SizedBox(width: AppDimensions.sectionPadding.w,),
              HeaderText(text: widget.text,color: Colors.white,)
            ],
          ) ,),
          AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                widthFactor: _widthAnimation.value,
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadius.r),
                    color: widget.endColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
