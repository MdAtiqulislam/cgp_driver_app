import 'package:cgp_driver_app/app/modules/statusSection/status_section.dart';
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/app/modules/generalMap/geneal_map_widget.dart';
import 'package:cgp_driver_app/common_widgets/custom_loading_screen.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    return SafeArea(
      child: Obx(
            () => Stack(
          children: [
            Scaffold(
              key: scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: scaffoldKey,
                enableBackButton: false,
              ),
              drawer: MyDrawer(),
              body: RefreshIndicator(
                onRefresh: () async {
                  await homeController.getRiderData();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                  ),
                  child: Column(
                    children: [
                      StatusSection(),
                      GeneralMapWidget(
                        showMarkers: false,
                        showPolyLine: false,
                        // isNotApproved: !(homeController.rider.value.isApproved??false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (homeController.isLoading.value) const LoadingScreen(),
          ],
        ),
      ),
    );
  }
}
