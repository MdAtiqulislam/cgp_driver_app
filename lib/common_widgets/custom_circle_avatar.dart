import 'package:flutter/material.dart';
import '../constraints/app_colors.dart';
import 'custom_network_image.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double width;
  final double height;
  final String image;
  final String? localImage;
  final double? radius;
  final double? border;
  final BoxFit? fit;
  final Color? bgColor;

  const CustomCircleAvatar(
      {required this.width,
      required this.height,
      required this.image,
      this.localImage,
      this.radius,
      this.border,
        this.fit,
        this.bgColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(border??0),
      clipBehavior: Clip.hardEdge,
      height: height,
      width: width,
      decoration: radius == null
          ?  BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor??AppColors.inactiveColor,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(radius!),
              color: bgColor??AppColors.inactiveColor,
            ),
      child: CustomNetworkImage(
        image: image,
        localImage: localImage,
        fit:fit
      ),
    );
  }
}
