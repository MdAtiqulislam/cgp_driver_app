import 'package:cgp_driver_app/app/modules/statusSection/select_vehicle.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/location_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../models/single_vehicle_model.dart';
import '../../../services/socket_service.dart';
import '../editProfile/models/rider_vehicles_model.dart';

class StatusSectionController extends GetxController {
  var isActive = true.obs;
  var isOnline = false.obs;
  var rider = RiderModel().obs;
  var isLoading = false.obs;
  var isLoadingVehicles = false.obs;
  var loadingStatus = false.obs;
  var riderVehicles = RiderVehiclesModel().obs;
  var selectedRiderVehicle=SingleVehicleModel().obs;
  var selectedVehicleTypeId = "".obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserData();
    await getSelectedVehicle();
  }

  Future<void> getUserData() async {
    await LocalServices.getUser().then((value) {
      if (value != null) {
        rider.value = value;
        if(rider.value.isApproved??false){
          isOnline.value = rider.value.isActive ?? true;
        }else{
          isOnline.value=false;
        }
        if (kDebugMode) {
          print("isApproved: ${rider.value.isApproved}");
        }
      }
    });
  }

  Future<void> changeOnlineStatus({required bool status}) async {
    if(status){
      selectVehicle();
    }else{
      isOnline.value=status;
      selectedRiderVehicle.value=SingleVehicleModel();
     // await LocalServices().storeSelectedVehicle(SingleVehicleModel());
      await LocalServices.storeSelectedVehicle(SingleVehicleModel());
      changeStatus();
    }

  }

  Future<RiderVehiclesModel> getRiderVehicle() async {
    isLoadingVehicles.value = true;
    var endPoint = APIEndPoints.getVehicles;
    try {
      var data = await RemoteServices.getRequest(endPoint: endPoint);
      if (data != null) {
        riderVehicles.value = RiderVehiclesModel.fromJson(data);
      }
    } finally {
      isLoadingVehicles.value = false;
    }
    return riderVehicles.value;
  }

  Future<void> selectVehicle() async {
      Get.bottomSheet(
        isScrollControlled: true,
        ignoreSafeArea: false,
        SelectVehicle(),
      );
      await getRiderVehicle();
  }

  Future<void> changeStatus() async {

    var body={};

    var position = await LocationServices.getCurrentLocation();
    loadingStatus.value = true;
    var endPoint = APIEndPoints.updateOnlineStatus;
    body = {
      "isActive": isOnline.value,
      "latitude": position.latitude,
      "longitude": position.longitude
    };
    if(isOnline.value) {
      body["vehicleId"]=selectedRiderVehicle.value.id;
    }

    try {
      var response =
          await RemoteServices.putRequestWithJson(endPoint: endPoint, body: body);
      if(response!=null){
        var riderJson=rider.toJson();
        riderJson["is_active"]=isOnline.value;
        rider.value=  RiderModel.fromJson(riderJson);
       // await LocalServices().storeUser(rider.value).then((value){
        await LocalServices.storeUser(rider.value).then((value){
          if(isOnline.value){
            // Get.find<SocketService>().disconnect();
            Get.find<SocketService>().startLocationUpdates();
          }else{
            Get.find<SocketService>().disconnect();
          }
        });


      }
    } finally {
      loadingStatus.value=false;
    }
  }

 Future<void> getSelectedVehicle() async{
    selectedRiderVehicle.value=await LocalServices.getSelectedVehicle()??SingleVehicleModel();
 }
}
