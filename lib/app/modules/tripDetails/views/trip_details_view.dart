import 'package:cgp_driver_app/common_widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_circle_avatar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../../utils/utils.dart';
import '../../../routes/app_pages.dart';
import '../../statusSection/status_section.dart';
import '../controllers/trip_details_controller.dart';

class TripDetailsView extends GetView<TripDetailsController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TripDetailsView({super.key});

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
                    Get.offAllNamed(Routes.HOME);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: Column(
                    children: [
                      StatusSection(
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                AppImagePath.searchIcon,
                                scale: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                      bodySection(),
                      SizedBox(height: AppDimensions.sectionPadding.h,)
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
              const HeaderText(
                text: "Time & Date: ",
                size: 12,
              ),
              BodyText(
                text: formatDateTime(
                    dateTimeString:
                        (controller.tripDetails.value.data?.acceptedAt ??
                                DateTime.now())
                            .toString()),
                color: AppColors.primaryColor,
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.contentPadding.h,
          ),
          Row(
            children: [
              CustomCircleAvatar(
                  width: 50,
                  height: 50,
                  image: controller.tripDetails.value.data?.requestFrom?.url ??
                      ""),
              SizedBox(
                width: AppDimensions.contentPadding.w,
              ),
              Expanded(
                child: HeaderText(
                  text:
                      "Trip From: ${controller.tripDetails.value.data?.requestFrom?.name ?? ""}",
                  size: 14,
                  maxLine: 3,
                ),
              ),
              BodyText(
                text: "${controller.tripDetails.value.data?.shippingStatus}",
                color: AppColors.primaryColor,
                size: 11,
              ),
            ],
          ),
          SizedBox(
            height: AppDimensions.contentPadding.h,
          ),
          const Divider(),
          addressSection(),
          SizedBox(
            height: AppDimensions.contentPadding.h,
          ),
          const Divider(),
          SizedBox(height: AppDimensions.contentPadding.h,),
          paymentSection(),
          SizedBox(height: AppDimensions.contentPadding.h,),
          const Divider(),
          SizedBox(height: AppDimensions.contentPadding.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const HeaderText(text: "Payment Received",size: 18,),
              CustomCheckBox(
                  padding: EdgeInsets.zero,
                  value: true, onChanged: (value){})
            ],
          ),
          SizedBox(height: AppDimensions.contentPadding.h,),
          Divider(),
          SizedBox(height: AppDimensions.contentPadding.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderText(text: "Client's Ratings:"),
              BodyText(
                text: "Not Given Yet",
              )
            ],
          ),
          SizedBox(
            height: AppDimensions.sectionPadding.h,
          ),
          const BodyText(text: "Get connected with CGP for more earnings.")
        ],
      ),
    );
  }

  Widget addressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          text: "Route completed",
          color: AppColors.primaryColor,
          size: 10,
        ),
        SizedBox(
          height: AppDimensions.contentPadding.h,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: "Pickup Location",
                    color: AppColors.primaryColor,
                    size: 12,
                  ),
                  BodyText(
                    text: controller
                            .tripDetails.value.data?.pickupLocation?.address ??
                        "",
                    maxLine: 3,
                  )
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
            SizedBox(
              width: AppDimensions.contentPadding.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: "Drop Point",
                    color: AppColors.primaryColor,
                    size: 12,
                  ),
                  BodyText(
                    text: controller
                            .tripDetails.value.data?.dropOffLocation?.address ??
                        "",
                    maxLine: 3,
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget paymentSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  const HeaderText(text: "Total Distance: ",size: 12,),
                  BodyText(text: "${controller.tripDetails.value.data?.distance??0} KM",color: AppColors.primaryColor,)
                ],
              ),
              Row(
                children: [
                  const HeaderText(text: "Total time: ",size: 12,),
                  BodyText(text: "${controller.tripDetails.value.data?.duration??0}",color: AppColors.primaryColor,)
                ],
              ),
            ],
          ),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const BodyText(text: "Trip Cost",size: 10,),
            HeaderText(text: "${controller.tripDetails.value.data?.riderFee??0} AUD",color: AppColors.primaryColor,size: 20,)
          ],
        ),),
      ],
    );
  }
}
