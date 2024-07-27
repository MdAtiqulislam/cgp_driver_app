import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/base_screen.dart';
import 'package:cgp_driver_app/common_widgets/custom_bottom_nav_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_drop_down_field.dart';
import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/service_type_controller.dart';

class ServiceTypeView extends GetView<ServiceTypeController> {
   ServiceTypeView({super.key});

  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      bottomNavBar: CustomBottomNavBar(
        content: AppButton(text: "Next",onTap: (){
        if(_formKey.currentState?.validate()??false){
          controller.openRegistration();
        }
      },bgColor: AppColors.primaryColor,),),
      body: Center(
        child: Form(
          key: _formKey,
          child: CustomDropDownField(
            lavelText: "Select Service Type",
            hintText: "Select Service Type",
            itemList: const ["Individual","Company"],
            validatorText: "Please select service type to continue",
            isRequired: true,
            onChange: (String? value) {
              controller.selectedServiceType=value??"";
            },
          ),
        ),
      ),
    );
  }
}
