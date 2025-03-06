import 'package:cgp_driver_app/app/modules/tripDetails/controllers/trip_details_controller.dart';
import 'package:cgp_driver_app/app/modules/tripHistory/models/trip_history_model.dart';
import 'package:cgp_driver_app/app/routes/app_pages.dart';
import 'package:cgp_driver_app/common_widgets/custom_circle_avatar.dart';
import 'package:cgp_driver_app/common_widgets/custom_ratings.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SingleTripCard extends StatelessWidget {
  final SingleTripHistoryModel tripHistoryModel;

  const SingleTripCard({super.key, required this.tripHistoryModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.put(TripDetailsController());
        Get.find<TripDetailsController>()
            .getTripDetails(id: tripHistoryModel.id.toString());
        Get.toNamed(Routes.TRIP_DETAILS);
      },
      child: Row(
        children: [
          CustomCircleAvatar(
              width: 50,
              height: 50,
              image: tripHistoryModel.requestFrom?.url ?? ""),
          SizedBox(
            width: AppDimensions.contentPadding.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  text: tripHistoryModel.requestFrom?.name ?? "",
                  maxLine: 3,
                ),
                BodyText(
                    text: getTimeDifference(
                        "${tripHistoryModel.deliveredAt ?? DateTime.now()}"))
              ],
            ),
          ),
          SizedBox(
            width: AppDimensions.contentPadding.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const HeaderText(
                    text: "Earned:",
                    size: 12,
                  ),
                  BodyText(
                    text: tripHistoryModel.riderFee ?? "0",
                    color: AppColors.primaryColor,
                    size: 14,
                  )
                ],
              ),
              CustomRatingWidget(
                  ratingValue: (tripHistoryModel.reviews?.received?.rating ?? 0)
                      .toDouble())
            ],
          )
        ],
      ),
    );
  }
}
