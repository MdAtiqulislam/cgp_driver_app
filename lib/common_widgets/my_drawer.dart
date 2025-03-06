import 'dart:io';

import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';
import '../other_controllers/my_drawer_controller.dart';
import 'custom_circle_avatar.dart';
import 'custom_loading_screen.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final MyDrawerController controller = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            Drawer(
              backgroundColor: Colors.white,
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Get.width * .8
                  : Get.width * .5,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 24.w, //AppDimensions.horizontalPadding,
                    vertical: 24.h //AppDimensions.verticalPadding
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*SizedBox(
                        height: 32.h//AppDimensions.sectionPaddingVer,
                      ),*/
                    Stack(
                      children: [
                        CustomCircleAvatar(
                          width: 70,
                          height: 70,
                          image: controller.rider.value.profileImageUrl??"",
                          localImage: AppImagePath.avatar,
                          bgColor: AppColors.primaryColor.withOpacity(.5),
                          fit: BoxFit.cover,
                        ),
                        /*Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.white54,
                                onTap: () {
                                  },
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    SizedBox(
                      height: AppDimensions.contentPadding.h,
                    ),
                    HeaderText(
                      text:
                          "${controller.rider.value.firstName ?? ""} ${controller.rider.value.lastName ?? ""}",
                      align: TextAlign.start,
                      maxLine: 3,
                    ),
                    BodyText(
                      text:
                          controller.rider.value.email ?? "",
                      align: TextAlign.start,
                      maxLine: 3,
                    ),
                    BodyText(
                      text:"04${controller.rider.value.phone ?? ""}",
                      align: TextAlign.start,
                      maxLine: 3,
                    ),
                    const Divider(),
                    drawerButton(
                        onTap: () {
                          Get.offAllNamed(Routes.HOME);
                        },
                        icon: const Icon(Icons.home_outlined,size: 16,color: AppColors.iconColor,),
                        imageIcon: "",
                        text: "Home"),

                    drawerButton(
                        onTap: () {
                          Get.offAndToNamed(Routes.EDIT_PROFILE);
                        },
                        imageIcon: AppImagePath.account,
                        text: "Profile"),
                    const Divider(),
                    drawerButton(
                        onTap: () {
                          Get.back();
                           Get.toNamed(Routes.TRIP_HISTORY);
                        },
                        imageIcon: AppImagePath.deliveryVan,
                        text: "Trip and Earning History"),
                    drawerButton(
                        onTap: () {
                          Get.toNamed(Routes.MY_WALLET);
                        },
                        imageIcon: AppImagePath.payment,
                        text: "My Wallet"),
                    const Divider(),
                    drawerButton(
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.TERMS_AND_CONDITION);
                        },
                        imageIcon: AppImagePath.infoIcon,
                        text: "Terms & Condition"),
                    drawerButton(
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.SUPPORT);
                          //Get.toNamed(Routes.SUPPORT);
                        },
                        imageIcon: AppImagePath.support,
                        text: "Customer Support/Helpline"),
                    drawerButton(
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.CHAT_HISTORY);
                          //Get.toNamed(Routes.SUPPORT);
                        },
                        icon: const Icon(Icons.chat,size: 16,color: AppColors.iconColor,),
                        imageIcon: AppImagePath.support,
                        text: "Messages"),
                    drawerButton(
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.FAQ_PAGE);
                          //Get.toNamed(Routes.SUPPORT);
                        },
                        icon: const Icon(Icons.question_mark_rounded,size: 16,color: AppColors.iconColor,),
                        imageIcon: AppImagePath.support,
                        text: "How To"),
                    const Divider(),
                    drawerButton(
                        onTap: () {
                          controller.logOut();
                        },
                        imageIcon: AppImagePath.logoutIcon,
                        text: "Log out"),

                   if(Platform.isIOS) drawerButton(
                        onTap: () {
                          controller.deleteAccount();
                        },
                        imageIcon:"",
                       icon:const Icon(Icons.delete,color: AppColors.iconColor,size: 16,),
                        text: "Delete Account"),
                  ],
                ),
              ),
            ),
              if (controller.isLoading.value) const LoadingScreen()
          ],

        ),
      ),
    );
  }

  Widget drawerButton(
      {required VoidCallback onTap,
      required String imageIcon,
        Widget? icon,
      required String text}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r)),
      child: Material(
        color: Colors.transparent,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Row(
              children: [
              icon ?? Image.asset(
                  imageIcon,
                  height: 16,
                  width: 16,
                ),
                SizedBox(
                  width: AppDimensions.widgetPadding.w,
                ),
                HeaderText(
                  text: text,
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
