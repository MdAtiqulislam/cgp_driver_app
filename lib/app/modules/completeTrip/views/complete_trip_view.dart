import 'package:cgp_driver_app/app/modules/reviewAndRatings/controllers/review_and_ratings_controller.dart';
import 'package:cgp_driver_app/app/modules/statusSection/status_section.dart';
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_circle_avatar.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/complete_trip_controller.dart';

class CompleteTripView extends GetView<CompleteTripController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CompleteTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              key: _scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
              ),
              drawer: MyDrawer(),
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                    vertical: AppDimensions.contentPadding.h),
                height: 60,
                child: AppButton(
                  text: "Back To Timeline",
                  bgColor: AppColors.primaryColor,
                  onTap: () {
                    Get.toNamed(Routes.HOME);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: Column(
                    children: [
                      StatusSection(),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                      bodySection(),
                    ],
                  ),
                ),
              ),
            ),
            if (controller.isLoading.value) const LoadingScreen()
          ],
        ),
      ),
    );
  }

  Widget bodySection() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding.w,
          vertical: AppDimensions.verticalPadding.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowColor, blurRadius: 10),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomCircleAvatar(width: 50, height: 50, image: ""),
              SizedBox(
                width: AppDimensions.contentPadding.w,
              ),
              Expanded(
                child: HeaderText(
                  text:
                      "Trip For: ${controller.tripRequestDetails.value.data?.requestFrom?.name ?? ""}",
                  size: 14,
                  maxLine: 3,
                ),
              ),
              const BodyText(
                text: "Completed",
                color: AppColors.primaryColor,
                size: 11,
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.contentPadding.h,
          ),
          const Divider(),
          SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          const HeaderText(
            text: "Congratulations!",
            color: AppColors.primaryColor,
            size: 18,
          ),
          SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          HeaderText(
            text:
                "Yoy have successfully completed the trip of \n ${controller.tripRequestDetails.value.data?.requestFrom?.name ?? ""}",
            maxLine: 4,
            size: 12,
          ),
          SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          const Divider(),
          /*SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderText(text: "Client's Ratings:"),
              BodyText(
                text: "Not Given Yet",
              )
            ],
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const HeaderText(text: "Earned:"),
              HeaderText(
                text:
                    "${controller.tripRequestDetails.value.data?.riderFee ?? ""} AUD",
                size: 20,
                color: AppColors.primaryColor,
              ),

            ],
          ),
          SizedBox(height: AppDimensions.sectionPadding.h,),
          Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: (){
                  Get.toNamed(Routes.MY_WALLET);
                },
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
                  child: const HeaderText(text: "View total earnings",color: AppColors.primaryColor,),
                )),
          ),
         SizedBox(height: AppDimensions.widgetPadding.h,),
         controller.isReviewed.value
             ?Row(children: [
               const HeaderText(text: "Reviewed",color: AppColors.primaryColor,),
           SizedBox(width: AppDimensions.contentPadding.w,),
           const Icon(Icons.check_box,color: AppColors.successColor,)
         ],)
             : Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () async {
                  Get.put(ReviewAndRatingsController());
                  Get.find<ReviewAndRatingsController>().tripDetails.value=controller.tripRequestDetails.value;
                  controller.isReviewed.value=await Get.toNamed(Routes.REVIEW_AND_RATINGS);
                },
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
                  child: const HeaderText(text: "Write a review",color: AppColors.primaryColor,),
                )),
          ),


          const Divider(),

          SizedBox(height: AppDimensions.sectionPadding.h,),
          const BodyText(text: "Get connected with CGP for more earnings.")
        ],
      ),
    );
  }
}
