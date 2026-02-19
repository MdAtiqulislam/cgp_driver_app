import 'package:flutter/material.dart';
import '../../constraints/app_colors.dart';

class CircularButton extends StatelessWidget {
 final double blurRadius;
 final Widget child;
 final VoidCallback? callback;
 final Offset? offset;
 final Color? bgColor;
 final Color? shadowColor;
 final double width;
 final double height;
 final Color? splashColor;
 final double shadowOpacity;
 final BoxShape shape;

  const CircularButton({
    super.key,
    this.bgColor,
    this.splashColor,
    required this.child,
    this.shadowColor,
    required this.callback,
    this.offset = const Offset(0, 3),
    this.blurRadius = 5,
    this.width = 45,
    this.height = 45,
    this.shadowOpacity=.5,
    this.shape=BoxShape.circle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration:
      BoxDecoration(
          shape: shape,
          color: bgColor??Colors.white, boxShadow: [
        BoxShadow(
            color: shadowColor?.withOpacity(shadowOpacity)??AppColors.shadowColor,
            spreadRadius: 0,
            blurRadius: blurRadius,
            offset: offset! // changes position of shadow
            ),
      ]),
      child: Material(
        color: bgColor,
        child: InkWell(
          onTap: callback,
          splashColor: splashColor??AppColors.primaryColor.withOpacity(.5),
          child: child,
        ),
      ),
    );
  }
}
