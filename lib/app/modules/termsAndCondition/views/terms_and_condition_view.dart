import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/terms_and_condition_controller.dart';

class TermsAndConditionView extends GetView<TermsAndConditionController> {
  final GlobalKey<ScaffoldState> scaffoldState=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        appBar: CustomAppBar(
          scaffoldKey: scaffoldState,
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Text(
            'Terms And Condition',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
