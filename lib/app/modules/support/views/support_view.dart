import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../controllers/support_controller.dart';

class SupportView extends GetView<SupportController> {
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
            'Support View',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
