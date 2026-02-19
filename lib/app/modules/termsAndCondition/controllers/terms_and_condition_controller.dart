import 'package:get/get.dart';

import '../../../../services/api_endpoints.dart';
import '../../../../services/remote_services.dart';
import '../models/terms_and_condition_model.dart';

class TermsAndConditionController extends GetxController {
  var isLoading = false.obs;

  var termsAndConditionModel=TermsAndConditionModel().obs;

  @override
  void onInit() async {
    super.onInit();
    await getTermsAndCondition();
  }


  @override
  void onClose() {}

  Future<void> getTermsAndCondition() async {
    isLoading.value=true;
    var link="${APIEndPoints.baseUrlMessaging}${APIEndPoints.getTermsAndCondition}";
    var parameters={
      "type":"rider"
    };

    try {
      var response=await RemoteServices.chatGetRequest(link: link,parameters: parameters);
      if(response!=null){
        termsAndConditionModel.value=TermsAndConditionModel.fromJson(response);
      }
    } finally {
      isLoading.value=false;
    }
  }
}
