import 'package:cgp_driver_app/app/modules/tripRequest/models/trip_request_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../services/api_endpoints.dart';
import '../../../../services/remote_services.dart';

class ReviewAndRatingsController extends GetxController {
  var tripDetails=TripRequestDetailsModel().obs;
  var rating = 5.0.obs;
  var reviewController = TextEditingController();
  var isLoading=false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> submitReview() async{
    isLoading.value=true;
    var endPoint=APIEndPoints.addReview;
    var body={
      "orderId": tripDetails.value.data?.orderId??"",
      "given_to": "customer",
      "given_to_id": tripDetails.value.data?.requestFrom?.id??"",
      "rating": rating.value,
      "review": reviewController.text
    };
    try {
      var response=await RemoteServices.postRequestWithJsonData(endPoint: endPoint,body: body);
      if(response!=null){
        Get.back(result: true);
        CustomSnackBar(
            isSuccess: true,
            msg: response["message"]
        ).showSnackBar();
      }else{
        CustomSnackBar(
            isSuccess: false,
            msg: AppStrings.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }
  }
}
