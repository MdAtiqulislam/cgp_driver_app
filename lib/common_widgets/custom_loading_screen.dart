import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constraints/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      color: Colors.black12,
      child: const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),),
    );
  }
}
