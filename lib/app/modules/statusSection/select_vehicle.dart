import 'package:cgp_driver_app/app/modules/editProfile/controllers/edit_profile_controller.dart';
import 'package:cgp_driver_app/app/modules/statusSection/status_section_controller.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/custom_circle_avatar.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/models/single_vehicle_model.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/app_strings.dart';
import '../../../constraints/dimensions.dart';
import '../../../constraints/header_text.dart';

class SelectVehicle extends StatelessWidget {
   SelectVehicle({super.key});

  final controller=Get.put(StatusSectionController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.contentPadding.h),
              width: Get.width,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const HeaderText(
                    text: "Select Vehicle",
                    color: Colors.white,
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.cancel_presentation_outlined,color: Colors.white,size: 25.sp,))
                ],
              ),
            ),
            Obx(
              () => Flexible(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.horizontalPadding.w,
                          vertical: AppDimensions.verticalPadding.h),
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  controller.riderVehicles.value.data?.length ??
                                      0,
                              itemBuilder: (buildContext, index) {
                                return Obx(() => InkWell(
                                      onTap: () async {
                                        controller.selectedVehicleTypeId.value =
                                            (controller
                                                        .riderVehicles
                                                        .value
                                                        .data?[index]
                                                        .type
                                                        ?.typeId ??
                                                    '')
                                                .toString();
                                        controller.selectedRiderVehicle.value =
                                            controller.riderVehicles.value
                                                    .data?[index] ??
                                                SingleVehicleModel();
                                       // await LocalServices().storeSelectedVehicle(controller.selectedRiderVehicle.value);
                                        await LocalServices.storeSelectedVehicle(controller.selectedRiderVehicle.value);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomCircleAvatar(
                                                  width: 50,
                                                  height: 50,
                                                  image: controller
                                                          .riderVehicles
                                                          .value
                                                          .data?[index]
                                                          .vehicleFrontImageUrl ??
                                                      "",
                                                localImage: AppImagePath.placeholderVehicle,
                                              ),
                                              SizedBox(
                                                width: AppDimensions
                                                    .widgetPadding.w,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    HeaderText(
                                                      text: controller
                                                              .riderVehicles
                                                              .value
                                                              .data?[index]
                                                              .type
                                                              ?.name ??
                                                          "",
                                                      maxLine: 3,
                                                    ),
                                                    BodyText(
                                                        text:
                                                            "Capacity: ${controller.riderVehicles.value.data?[index].type?.vehicleCapacity ?? "0"}"),
                                                    BodyText(
                                                        text:
                                                            "Licence Plate: ${controller.riderVehicles.value.data?[index].licensePlate ?? "N/A"}"),
                                                    BodyText(
                                                        text:
                                                            "Model: ${controller.riderVehicles.value.data?[index].model ?? "N/A"}"),
                                                  ],
                                                ),
                                              ),
                                              if (controller
                                                      .selectedRiderVehicle
                                                      .value.id.toString() ==
                                                  (controller
                                                              .riderVehicles
                                                              .value
                                                              .data?[index]
                                                              .id.toString())
                                                      .toString())
                                                const Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: AppColors.successColor,
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              }),
                          SizedBox(
                            height: AppDimensions.sectionPadding.h,
                          ),
                          if((controller.riderVehicles.value.data??[]).isNotEmpty)AppButton(
                              text: "Continue",
                              bgColor: AppColors.primaryColor,
                              onTap: () {
                                  Get.back();
                                controller.isOnline.value=true;
                                controller.changeStatus();
                              }),
                          if((controller.riderVehicles.value.data??[]).isEmpty)AppButton(
                              text: "Add new vehicle",
                              bgColor: AppColors.primaryColor,
                              onTap: () async {
                                /*  Get.back();
                                controller.isOnline.value=true;
                                controller.changeStatus();*/
                                Get.put(EditProfileController());
                                Get.find<EditProfileController>().isExpand.value=[false,true,false];
                                await Get.toNamed(Routes.EDIT_PROFILE)?.then((value){
                                  controller.getRiderVehicle();
                                });
                              }),
                        ],
                      ),
                    ),
                    if (controller.isLoadingVehicles.value) const Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(child: CircularProgressIndicator()))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
