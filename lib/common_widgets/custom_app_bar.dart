
/*

import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';
import '../other_controllers/appbar_controller.dart';
import 'custom_circle_avatar.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool minimal;
  final bool enableBackButton;
  final VoidCallback? openDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? title;
  final Function? onTrouble;
  final double? titleTextSize;

  CustomAppBar(
      {this.scaffoldKey,
      this.openDrawer,
      this.minimal = false,
      this.enableBackButton = false,
      super.key,
      this.title,
      this.onTrouble,
      this.titleTextSize});

  final appBarController = Get.put(AppbarController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 70.h,
        margin:
            EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lineColor, width: 1.h),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(enableBackButton)IconButton(onPressed: (){Get.back();}, icon: const Icon(Icons.arrow_back,color: AppColors.primaryColor,)),
            minimal
                ? const HeaderText(text: "TradeBar - Driver",color: AppColors.primaryColor,)
                : IgnorePointer(
                    ignoring: Get.currentRoute == Routes.HOME,
                    child: const HeaderText(text: "TradeBar - Driver",color: AppColors.primaryColor,),
                  ),
            if (appBarController.isLoading.value)
              const BodyText(text: "Loading..."),
            minimal
                ? InkWell(
                    onTap: () {
                      if (onTrouble != null) {
                        onTrouble!();
                      }
                    },
                    child: BodyText(
                      text: title ?? "Vehicle Provider",
                      color: AppColors.primaryColor,
                      size: titleTextSize ?? 10,
                    ),
                  )
                : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () {

                            appBarController.openNotificationPage();
                            /*Get.put(NotificationsController());
                            Get.find<NotificationsController>()
                                .getNotifications();
                            Get.toNamed(Routes.NOTIFICATIONS);*/
                          },
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.asset(
                                    AppImagePath.notificationIcon,
                                    //height: 50,
                                  ),
                                  if (appBarController
                                          .unreadNotifications.value >
                                      0)
                                    Positioned(
                                      top: -5,
                                      right: -10,
                                      child: Container(
                                        clipBehavior: Clip.none,
                                        height: 18,
                                        width: 18,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.errorColor),
                                        child: Center(
                                          child: BodyText(
                                            text: (appBarController
                                                        .unreadNotifications) >=
                                                    10
                                                ? "9+"
                                                : "${appBarController.unreadNotifications}",
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 24.w,
                        ),
                        InkWell(
                          onTap: () {
                            scaffoldKey?.currentState?.openDrawer();
                          },
                          child: CustomCircleAvatar(
                            width: 30,
                            height: 30,
                            image: appBarController
                                    .riderModel.value.profileImageUrl ??
                                "",
                            localImage: AppImagePath.avatar,
                          ),
                        ),
                        SizedBox(
                          width: 24.w,
                        ),
                        InkWell(
                          onTap: () {
                            scaffoldKey?.currentState?.openDrawer();
                          },
                          child: Image.asset(
                            AppImagePath.menuBar,
                            height: 30,
                          ),
                        ),
                        /*SizedBox(
                        width: 24.w,
                      )*/
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, 70.h);
}


 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/dimensions.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import '../other_controllers/appbar_controller.dart';
import 'custom_circle_avatar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool minimal;
  final bool? enableBackButton;
  final VoidCallback? openDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? title;
  final Function? onTrouble;
  final double? titleTextSize;

  CustomAppBar({
    super.key,
    this.scaffoldKey,
    this.openDrawer,
    this.minimal = false,
    this.enableBackButton,
    this.title,
    this.onTrouble,
    this.titleTextSize,
  });

  final appBarController = Get.put(AppbarController());

  @override
  Widget build(BuildContext context) {
    bool canPop = enableBackButton ?? Navigator.of(context).canPop();

    return Obx(
          () => Container(
        height: 70.h,
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lineColor, width: 1.h),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (canPop)
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
              ),
            minimal
                ? const Expanded(
              child: HeaderText(
                                text: "TradeBar - Driver",
                                color: AppColors.primaryColor,
                                size: 18,
                                align: TextAlign.start,
                              ),
                )
                : const Expanded(
              child: HeaderText(
                text:  "TradeBar - Driver",
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
            if (appBarController.isLoading.value)
              const BodyText(text: "Loading..."),
            minimal
                ? BodyText(
              text: title??"Account",
              color: AppColors.primaryColor,
              size:titleTextSize?? 10,
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildNotificationIcon(),
                SizedBox(width: AppDimensions.widgetPadding.w),
                InkWell(
                  onTap: () => scaffoldKey?.currentState?.openDrawer(),
                  child: CustomCircleAvatar(
                    width: 30.r,
                    height: 30.r,
                    image: appBarController.riderModel.value.profileImageUrl ?? "",
                    localImage: AppImagePath.avatar,
                  ),
                ),
                SizedBox(width: AppDimensions.widgetPadding.w),
                InkWell(
                  onTap: () => scaffoldKey?.currentState?.openDrawer(),
                  child: Image.asset(
                    AppImagePath.menuBar,
                    height: 30.r,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return InkWell(
      onTap: appBarController.openNotificationPage,
      child: SizedBox(
        height: 30.r,
        width: 30.r,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none_rounded,size: 30.r,color: AppColors.iconColor,),
             // Image.asset(AppImagePath.notificationIcon),
              if (appBarController.unreadNotifications.value > 0)
                Positioned(
                  top: -5,
                  right: -10,
                  child: Container(
                    height: 22.r,
                    width: 22.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.errorColor,
                    ),
                    child: Center(
                      child: BodyText(
                        text: appBarController.unreadNotifications >= 10 ? "9+" : "${appBarController.unreadNotifications}",
                        color: Colors.white,
                        size: 10.r,
                        resize: false,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, 70.h);
}
