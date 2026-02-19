import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../services/api_endpoints.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../models/issueListModel.dart';
import '../models/issue_status_list_model.dart';

class SupportController extends GetxController {
  var isLoading=false.obs;
  var issueSubjectListModel=IssueSubjectListModel().obs;
  var issueListModel=IssueListModel().obs;

  var rider=RiderModel().obs;

  var selectedStatus=SingleIssueSubjectModel().obs;

  var descriptionController=TextEditingController();

  @override
  void onInit() async{
    super.onInit();
    await getUserData();
    await fetchIssueList();
    await fetchIssueSubjectList();
  }

  Future<void> addSupport() async{
    isLoading.value=true;
    var link="${APIEndPoints.baseUrlMessaging}${APIEndPoints.createSupportEndPoint}";
    var body={
      "issued_by_id":rider.value.id,
      "issued_by_type_id":"23",
      "subject":selectedStatus.value.name,
      "description":descriptionController.text,
    };
    try {
      var response=await RemoteServices.chatPostRequest(url: link,body: body);
      if(response!=null){
        CustomSnackBar(
            isSuccess: true,
            msg: response["message"]
        ).showSnackBar();
         selectedStatus.value=SingleIssueSubjectModel();
         descriptionController.text="";
        await fetchIssueList();
      }
    } finally {
      isLoading.value=false;
    }

  }

  Future<void> fetchIssueList() async {
    isLoading.value=true;
    var link="${APIEndPoints.baseUrlMessaging}${APIEndPoints.getSupportList}";
    var parameter={
      "issued_by_id":rider.value.id.toString(),
      "issued_by_type_id":"23"
    };
    try {
      var response=await RemoteServices.chatGetRequest(link: link,parameters: parameter);
      if(response!=null){
        issueListModel.value=IssueListModel.fromJson(response);
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void> getUserData() async{
    rider.value=await LocalServices.getUser()??RiderModel();
  }

  Future<void> fetchIssueSubjectList()async {
    isLoading.value=true;
    var link="${APIEndPoints.baseUrlMessaging}${APIEndPoints.getIssueSubjectList}";
    var parameters={
      "user_type":"rider"
    };

    try {
      var response=await RemoteServices.chatGetRequest(link: link,parameters: parameters);
      if(response!=null){
        issueSubjectListModel.value=IssueSubjectListModel.fromJson(response);
        selectedStatus.value=issueSubjectListModel.value.data?.first??SingleIssueSubjectModel();
      }
    } finally {
      isLoading.value=false;
    }

  }
}
