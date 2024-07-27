import 'package:cgp_driver_app/app/modules/tripHistory/models/trip_history_model.dart';
import 'package:cgp_driver_app/app/modules/tripHistory/views/single_trip_card.dart';
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_title.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/dimensions.dart';
import '../../../routes/app_pages.dart';
import '../../statusSection/status_section.dart';
import '../controllers/trip_history_controller.dart';

class TripHistoryView extends GetView<TripHistoryController> {
   TripHistoryView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
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
              body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: StatusSection(
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
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                    ),
                    const SliverToBoxAdapter(child: CustomTitle(title: "My Trip History",),),
                    bodySection(),
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

 Widget bodySection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(

        childCount: controller.tripHistory.value.data?.length??0,
          (buildContext,index){
          return Column(
            children: [
              SingleTripCard(tripHistoryModel: controller.tripHistory.value.data?[index]??SingleTripHistoryModel(),),
              if(index<(controller.tripHistory.value.data?.length??0)-1)Padding(
                padding:  EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
                child: const Divider(),
              )
            ],
          );
          }
    ),);
 }
}
