import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_strings.dart';
import '../constraints/dimensions.dart';
import 'custom_app_bar.dart';
import 'custom_loading_screen.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final bool showSlider;
  final bool showLoading;
  final bool isCenter;
  final Widget? bottomNavBar;

  BaseScreen(
      {required this.body,
      this.showSlider = true,
      this.showLoading = false,
      this.isCenter = true,
      this.bottomNavBar,
      super.key});

  final List<String> images = [
    "assets/images/slider_1.png",
    "assets/images/slider_2.png",
    "assets/images/slider_3.png",
    "assets/images/slider_4.png",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  CustomAppBar(
          minimal: true,
        ),
        bottomNavigationBar: bottomNavBar,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                if (showSlider)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.horizontalPadding.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: AppDimensions.sectionPadding.h,
                          ),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle
                            ),
                            child: Image.asset(AppImagePath.appIcon,scale: 3,),),

                          // CustomImageSlider(items: images, height: 130.h)
                        ],
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppDimensions.sectionPadding.h,
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: isCenter
                      ? Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.horizontalPadding.w),
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(width: Get.width, child: body),
                                SizedBox(
                                  height: AppDimensions.sectionPadding.h,
                                )
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.horizontalPadding.w),
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(width: Get.width, child: body),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              )
                            ],
                          ),
                        ),
                ),
              ],
            ),
            if (showLoading) const LoadingScreen()
          ],
        ),
      ),
    );
  }
}
