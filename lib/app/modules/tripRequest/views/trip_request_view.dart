import 'package:cgp_driver_app/app/modules/statusSection/status_section.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/views/client_info_card.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/views/warehouse_info_card.dart';
import 'package:cgp_driver_app/common_widgets/custom_loading_screen.dart';
import 'package:cgp_driver_app/app/modules/generalMap/geneal_map_widget.dart';
import 'package:cgp_driver_app/common_widgets/custom_switch.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../constraints/dimensions.dart';
import '../controllers/trip_request_controller.dart';

class TripRequestView extends GetView<TripRequestController> {
   TripRequestView({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              key: scaffoldKey,
              appBar:  CustomAppBar(
                scaffoldKey: scaffoldKey,
              ),
              drawer: MyDrawer(),
              body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w),
                child: Column(
                  children: [
                    StatusSection(
                    ),
                    SizedBox(
                      height: AppDimensions.sectionPadding.h,
                    ),
                     GeneralMapWidget(),
                    SizedBox(
                      height: AppDimensions.widgetPadding.h,
                    ),
                   controller.isClientMode.value
                       ? ClientInfoCard(
                      isExpanded: controller.isExpand.value,
                      changeExpandMode: (value) {
                        controller.isExpand.value = value;
                      },
                     onAccepted: (){
                        controller.onTripAccepted();
                     },
                     onDecline: (){},
                    )
                       : WareHouseInfoCard(
                     changeExpandMode: (value) {
                       controller.isExpand.value = value;
                     },
                     onAccepted: () {
                       controller.onTripAccepted();
                     },
                     onDecline: () {  },),
                    SizedBox(
                      height: AppDimensions.widgetPadding.h,
                    ),
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

  Widget trailingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: AppDimensions.contentPadding.w,),
        clientModeButton(),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            AppImagePath.callIcon,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            AppImagePath.messageIcon,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            AppImagePath.searchIcon,
            scale: 2,
          ),
        )
      ],
    );
  }

  Widget clientModeButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const BodyText(text: "Client Mode",color: AppColors.secondaryColor,size: 10,),
        SizedBox(height: AppDimensions.contentPadding.h,),
        CustomSwitch(value:controller.isClientMode.value , onChanged: (value){

          controller.isClientMode.value=value;
        })
      ],
    );
  }


}


