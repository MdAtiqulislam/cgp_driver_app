import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/custom_circle_avatar.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ClientInfoCard extends StatelessWidget {
  final bool isExpanded;
  final Function(bool) changeExpandMode;
  final Function() onAccepted;
  final Function() onDecline;


  const ClientInfoCard(
      {this.isExpanded = true,
        required this.changeExpandMode,
        required this.onAccepted,
        required this.onDecline,
        super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadowColor, blurRadius: 5, spreadRadius: 2)
          ]),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              changeExpandMode(!isExpanded);
            },
            child: Image.asset(
              isExpanded?AppImagePath.expandMoreIcon:AppImagePath.expandLessIcon,
              height: 10,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.widgetPadding.w,
                vertical: AppDimensions.contentPadding.h),
            child: isExpanded
                ? Column(
                  children: [
                    clientInfoSection(),
                    SizedBox(
                      height: AppDimensions.contentPadding.h,
                    ),
                    clientStatusSection(),
                    SizedBox(
                      height: AppDimensions.contentPadding.h,
                    ),
                    Divider(),
                    tripInfoSection(),
                    SizedBox(height: AppDimensions.widgetPadding.h,),
                    buttonSection()
                  ],
                )
                : clientInfoSection(),
          ),
        ],
      ),
    );
  }

  Widget clientInfoSection() {
    return Row(
      children: [
        const CustomCircleAvatar(width: 40, height: 40, image: ""),
        SizedBox(
          width: AppDimensions.contentPadding.w,
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
                text: "John Doe",
                size: 16,
                fontWeight: FontWeight.w500,
              ),
              BodyText(
                text: "Lorem ipsum street, South Lorem ipsum, 1230",
                maxLine: 3,
              ),
            ],
          ),
        ),
        const Column(
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
                  color: AppColors.placeholderColor,
                  size: 15,
                ),
              ],
            ),
            BodyText(
              text: "5 minutes away",
              size: 10,
            )
          ],
        )
      ],
    );
  }

  Widget clientStatusSection() {
    return Column(
      children: [
        Row(
          children: [
            HeaderText(text: "Trip Request:",size: 12,),
            BodyText(text: " Pending",color: AppColors.primaryColor,size: 12,)
          ],
        ),
        Row(
          children: [
            HeaderText(text: "Payment System:",size: 12,),
            BodyText(text: " Cash on delivery",color: AppColors.primaryColor,size: 12,)
          ],
        ),
      ],
    );
  }

  Widget tripInfoSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  HeaderText(
                    text: "Total Distance:",
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  BodyText(
                    text: " 17.8 KM",
                    color: AppColors.primaryColor,
                    size: 12,
                  ),
                ],
              ),
              Row(
                children: [
                  HeaderText(
                    text: "Total Weight:",
                    size: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  BodyText(
                    text: " 10 Tons",
                    color: AppColors.primaryColor,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BodyText(text: "Trip Cost"),
            HeaderText(
              text: "120 AUD",
              size: 20,
              color: AppColors.primaryColor,
            )
          ],
        )
      ],
    );
  }

  Widget buttonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton(
          text: "Accept",
          onTap: () {
            onAccepted();
          },
          bgColor: AppColors.primaryColor,
          borderRadius: 10,
          horizontalPadding: AppDimensions.horizontalPadding*2.w,
        ),
        AppButton(
          text: "Decline",
          onTap: () {
            onDecline();
          },
          bgColor: AppColors.errorColor,
          borderRadius: 10,
          horizontalPadding: AppDimensions.horizontalPadding*2.w,
        )
      ],
    );
  }
}
