import 'package:cgp_driver_app/app/modules/notifications/models/notifications_model.dart';
import 'package:cgp_driver_app/app/modules/notifications/views/single_notification_card.dart';
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_loading_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_title.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: scaffoldKey,
        ),
        drawer: MyDrawer(
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w),
              child: Stack(
                children: [
                  bodyContent(),
                  if (controller.isLoading.value) const LoadingScreen()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyContent() {
    return Column(
      children: [
        SizedBox(
          height: AppDimensions.sectionPadding.h,
        ),
        const CustomTitle(title: "Notifications"),
        ListView.builder(
            itemCount: controller.notificationsModel.value.data?.length??0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return SingleNotificationCard(
                notificationModel:
                    controller.notificationsModel.value.data?[index] ??
                        SingleNotificationModel(),
                onTap: () {
                  controller.handelClick(
                      requestedId:controller.notificationsModel.value.data?[index].data?.requestId??"",
                  notificationId: controller.notificationsModel.value.data?[index].id??""
                  );
              },
              );
            })
      ],
    );
  }
}
