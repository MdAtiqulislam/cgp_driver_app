import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../constraints/app_colors.dart';

class ShimmerScreen extends StatelessWidget {
  const ShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (buildContext, index) {
          return Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.only(bottom: 8.h//AppDimensions.contentPaddingVer
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                Border.all(color: AppColors.bodyTextColor, width: .1),
                borderRadius: BorderRadius.all(
                    Radius.circular(15.r)),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 2,
                  )
                ]),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical:8.h// AppDimensions.contentPaddingVer
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: const Color(0xffd9d9d9),
                    highlightColor: const Color(0xfff2f2f2),
                    child: Container(
                      width: Get.width,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height:16.h// AppDimensions.widgetPaddingVer,
                  ),
                  Shimmer.fromColors(
                    baseColor: const Color(0xffd9d9d9),
                    highlightColor: const Color(0xfff2f2f2),
                    child: Container(
                      width: Get.width * .5,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height:8.h// AppDimensions.contentPaddingVer,
                  ),
                  Shimmer.fromColors(
                    baseColor: const Color(0xffd9d9d9),
                    highlightColor: const Color(0xfff2f2f2),
                    child: Container(
                      width: Get.width * .5,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height:8.h// AppDimensions.contentPaddingVer,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xffd9d9d9),
                          highlightColor: const Color(0xfff2f2f2),
                          child: Container(
                            //  width: Get.width * .5,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width:8.w,// AppDimensions.contentPaddingHor,
                      ),
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xffd9d9d9),
                          highlightColor: const Color(0xfff2f2f2),
                          child: Container(
                            // width: Get.width * .5,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w//AppDimensions.contentPaddingHor,
                      ),
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xffd9d9d9),
                          highlightColor: const Color(0xfff2f2f2),
                          child: Container(
                            //   width: Get.width * .5,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width:8.w// AppDimensions.contentPaddingHor,
                      ),
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xffd9d9d9),
                          highlightColor: const Color(0xfff2f2f2),
                          child: Container(
                            //  width: Get.width * .5,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
