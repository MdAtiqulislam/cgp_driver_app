import 'package:cgp_driver_app/app/modules/generalMap/general_map_controller.dart';
import 'package:cgp_driver_app/app/modules/home/controllers/home_controller.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class GeneralMapWidget extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final Color borderColor;
  final double borderWidth;
  final bool myLocationEnabled;
  final MapType mapType;
  final double height;
  final bool showPolyLine;
  final bool showMarkers;
  final bool showNavigation;
  final bool zoomEnable;
  //final bool? isNotApproved;
  final Function()? startNavigation;

  final bool showNavigationButton;

   GeneralMapWidget(
      {super.key,
      this.margin = const EdgeInsets.all(8.0),
      this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
      this.borderColor = Colors.grey,
      this.borderWidth = 1.0,
      this.myLocationEnabled = true,
      this.mapType = MapType.normal,
      this.height = 400.0,
      this.showMarkers = true,
      this.showPolyLine = true,
      this.showNavigation = true,
      this.startNavigation,
      //this.isNotApproved,
      this.showNavigationButton = false,
      this.zoomEnable=false
      });

  final mapController = Get.put(GeneralMapController());
  @override
  Widget build(BuildContext context) {


    return Obx(
      () => Expanded(
        child: mapController.isLoading.value
            ? const CircularProgressIndicator()
            : Container(
                clipBehavior: Clip.hardEdge,
                margin: margin,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(color: borderColor, width: borderWidth),
                ),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                  ),
                  child: Obx(
                    () => mapController.isLoading.value
                        ? const CircularProgressIndicator()
                        : Stack(
                            children: [
                              GoogleMap(
                                zoomControlsEnabled: zoomEnable,
                                onMapCreated: mapController.onMapCreated,
                                myLocationEnabled: myLocationEnabled,
                                mapType: mapType,
                                initialCameraPosition:
                                    mapController.initialCameraPosition,
                                onCameraMove: mapController.onCameraMove,
                                polylines: showPolyLine
                                    ? mapController.polyLines.value
                                    : {},
                                markers:
                                    showMarkers ? mapController.markers : {},
                              ),
                              if (!mapController.isApproved.value)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.3),
                                    child: Center(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: AppDimensions
                                                  .horizontalPadding.w),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: AppDimensions
                                                  .contentPadding.w,
                                              vertical: AppDimensions
                                                  .verticalPadding.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimensions
                                                          .borderRadius.r),
                                              color: Colors.black54),
                                          child: const HeaderText(text: "Your account is under review.",color: Colors.white,size: 28,maxLine: 5,align: TextAlign.center,),
                                      ),
                                      ),
                                    ),
                                  ),
                              if (showNavigationButton)
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: MaterialButton(
                                    color: AppColors.primaryColor,
                                    onPressed: () {
                                      if (startNavigation != null) {
                                        startNavigation!();
                                      }
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.navigation_sharp,
                                          color: Colors.white,
                                        ),
                                        HeaderText(
                                          text: "Start Navigation",
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              if (!mapController.isApproved.value)
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryColor
                                    ),
                                    child: IconButton(
                                      splashColor: Colors.white,
                                      onPressed: (){
                                        Get.put(HomeController());
                                        Get.find<HomeController>().reloadData();
                                      },
                                      icon: const Icon(Icons.refresh,color: Colors.white,),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
