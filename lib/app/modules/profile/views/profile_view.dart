import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/custom_circle_avatar.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/dimensions.dart';
import '../../statusSection/status_section.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              key: scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: scaffoldKey,
              ),
              drawer: MyDrawer(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: Column(
                    children: [
                      StatusSection(
                        showOnlineStatus: false,
                        title: "Main Timeline",
                      ),
                      headerSection(),
                      infoSection(),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                     /* statisticsSection(),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),*/
                      /*const CustomTitle(title: "Notifications"),
                      notificationSection(),
                      SizedBox(height: AppDimensions.sectionPadding.h,),
                      const CustomTitle(title: "Notifications"),
                      tripHistoryButton(),*/
                      SizedBox(height: AppDimensions.sectionPadding.h,),
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

  Widget headerSection() {
    return Column(
      children: [
        Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
            ),
            child: Image.asset(
              "assets/images/slider_3.png",
              width: Get.width,
              height: 150.h,
              fit: BoxFit.cover,
            )),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 60.h,
              // color: Colors.red,
            ),
            Positioned(
              left: AppDimensions.horizontalPadding.w,
              top: -30,
              child: CustomCircleAvatar(
                image:controller.rider.value.profileImageUrl?? "",
                width: 80,
                height: 80,
               // border: 1,
                fit: BoxFit.cover,
                bgColor: Colors.white,
              ),
            ),
            Positioned(
              right: AppDimensions.horizontalPadding.w,
              top: AppDimensions.contentPadding.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.warningColor,
                        size: 15,
                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.warningColor,
                        size: 15,
                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.warningColor,
                        size: 15,
                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.warningColor,
                        size: 15,
                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.inactiveColor,
                        size: 15,
                      ),
                    ],
                  ),
                  HeaderText(
                    text: "Rating: 4",
                    size: 12,
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget infoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
                  text: "${controller.rider.value.firstName ?? ""} "
                      "${controller.rider.value.lastName ?? ""}"),
              SizedBox(
                height: AppDimensions.contentPadding.h,
              ),
              BodyText(
                  text:
                      "Driving License: ${controller.rider.value.drivingLicenseNumber ?? "N/A"}"),
              BodyText(text: "Vehicle License: N/A"),
              BodyText(text: "Driving Experience: N/A"),
              BodyText(text: "Total Trip Completed: N/A"),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Get.toNamed(Routes.EDIT_PROFILE);
          },
          icon: Image.asset(
            AppImagePath.editIcon,
            scale: 2,
          ),
        ),
      ],
    );
  }

  Widget statisticsSection() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.widgetPadding.w,
          vertical: AppDimensions.contentPadding.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          color: Colors.white,
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 5)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderText(
                text: "Earned Today",
                size: 16,
              ),
              HeaderText(
                text: "449.36 AUD",
                size: 16,
                color: AppColors.primaryColor,
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Total Trips",
                    size: 10,
                  ),
                  HeaderText(
                    text: "02",
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Online Time",
                    size: 10,
                  ),
                  HeaderText(
                    text: "07 h 30 m",
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Online Distance",
                    size: 10,
                  ),
                  HeaderText(
                    text: "55.5 km",
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget notificationSection() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.widgetPadding.w,
          vertical: AppDimensions.widgetPadding.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowColor, blurRadius: 5)
          ]),
      child: ListView.separated(
        itemCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (buildContext, index) {
          return singleNotificationCard(index: index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding:  EdgeInsets.symmetric(vertical: AppDimensions.widgetPadding.h),
            child: Divider(),
          );
        },
      ),
    );
  }

  Widget singleNotificationCard({required int index}) {
    return Row(
      children: [
        CustomCircleAvatar(
          width: 40,
          height: 40,
          image: "",
          localImage: "assets/images/moc_image_${index % 10}.png",
        ),
        SizedBox(width: AppDimensions.contentPadding.w,),
        Expanded(
          child: HeaderText(
            text: "Delivery Request from Timber Mart",
            maxLine: 4,
            color: AppColors.primaryColor,
            size: 14,
          ),
        ),
        SizedBox(width: AppDimensions.contentPadding.w,),
        BodyText(text: "${(index+1)*5} Minutes ago",size: 10,)
      ],
    );
  }

  Widget tripHistoryButton(){
    return Container(
      width: Get.width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowColor, blurRadius: 5)
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            Get.toNamed(Routes.TRIP_HISTORY);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.widgetPadding.w,
                vertical: AppDimensions.widgetPadding.h),
            child: HeaderText(text: "Trip History",),
          ),
        ),
      ),
    );
  }
 Widget tripHistorySection() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.widgetPadding.w,
          vertical: AppDimensions.widgetPadding.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowColor, blurRadius: 5)
          ]),
      child: Column(
        children: [
          ListView.separated(
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return singleTripCard(index: index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding:  EdgeInsets.symmetric(vertical: AppDimensions.widgetPadding.h),
                child: Divider(),
              );
            },
          ),
          Divider(),
          if(3==3)AppButton(text: "View all", onTap: (){})
        ],

      ),
    );
 }

}

Widget singleTripCard({required int index}) {
  return Row(
    children: [
      CustomCircleAvatar(
        width: 40,
        height: 40,
        image: "",
        localImage: "assets/images/moc_image_${index % 10}.png",
      ),
      SizedBox(width: AppDimensions.contentPadding.w,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Timber Mart",
              maxLine: 4,
              color: AppColors.primaryColor,
              size: 14,
            ),
            BodyText(text: "${(index+1)*3} Days ago")
          ],
        ),
      ),
      SizedBox(width: AppDimensions.contentPadding.w,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              HeaderText(text: "Earned: ",size: 12,),
              HeaderText(text: "190 AUD ",size: 12,color: AppColors.primaryColor,),

            ],
          ),
          Row(
            children: [
              Icon(Icons.star,color: AppColors.warningColor,size: 14,),
              Icon(Icons.star,color: AppColors.warningColor,size: 14,),
              Icon(Icons.star,color: AppColors.warningColor,size: 14,),
              Icon(Icons.star,color: AppColors.warningColor,size: 14,),
              Icon(Icons.star,color: AppColors.inactiveColor,size: 14,),
            ],
          )
        ],
      )
    ],
  );
}
