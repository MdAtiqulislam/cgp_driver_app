import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {


  var isLoading=false.obs;
  var rider=RiderModel().obs;
  @override
  void onInit() async{
    super.onInit();
    await getUserData();
  }


  @override
  void onClose() {}

 Future<void> getUserData()async {
    await LocalServices.getUser().then((value){
      if(value!=null){
        rider.value=value;
      }
    });
 }

}
