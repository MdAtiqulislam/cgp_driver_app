/*
import 'package:carousel_slider/carousel_slider.dart'as custom_carousel_slider;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';
import '../constraints/dimensions.dart';

class CustomImageSlider extends StatelessWidget {
  final List<String> items;
  final double height;
  final bool autoPlay;
  final bool revers;

  CustomImageSlider(
      {super.key,
      required this.items,
      required this.height,
      this.autoPlay = true,
      this.revers = false});

  var dotPosition = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        custom_carousel_slider.CarouselSlider(
          items: items.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    clipBehavior: Clip.hardEdge,
                    width: MediaQuery.of(context).size.width,
                    // margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius.r)),
                    child: Image.asset(
                      i,
                      fit: BoxFit.cover,
                    ));
              },
            );
          }).toList(),
          options: custom_carousel_slider.CarouselOptions(
            clipBehavior: Clip.hardEdge,
            height: height,
            aspectRatio: 1,
            viewportFraction: 1,
            initialPage: 1,
            enableInfiniteScroll: false,
            reverse: revers,
            autoPlay: autoPlay,
            onPageChanged: (i, r) {
              dotPosition.value = i;
            },
          ),
        ),
        Positioned(bottom: 0, left: 0, right: 0, child: dotIndicator())
      ],
    );
  }

  Widget dotIndicator() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    AppDimensions.borderRadius.r,
                  ),
                  bottomRight: Radius.circular(AppDimensions.borderRadius.r)),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(.5),
                    Colors.transparent,
                  ])),
          child: Center(
            child: DotsIndicator(
              mainAxisAlignment: MainAxisAlignment.center,
              dotsCount: items.length, //images.isEmpty ? 1 : images.length,
              position: dotPosition.value,
              decorator: DotsDecorator(
                color: Colors.white,
                activeColor: AppColors.primaryColor,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ));
  }
}
*/
