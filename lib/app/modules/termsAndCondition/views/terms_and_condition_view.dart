import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../controllers/terms_and_condition_controller.dart';

class TermsAndConditionView extends GetView<TermsAndConditionController> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TermsAndConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          minimal: false,
          scaffoldKey: scaffoldKey,
        ),
        drawer: MyDrawer(),
        body: Obx(
              () => Stack(
            children: [
              SingleChildScrollView(
                padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
                child: Html(
                  data: controller.termsAndConditionModel.value.data?[0].info ??
                      "",
                  style: {
                    "body": Style(
                      fontSize: FontSize(16.0),
                      lineHeight: const LineHeight(1.6),
                      color: Colors.black87,
                    ),
                    "h1": Style(
                      fontSize: FontSize(24.0),
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                      color: AppColors.primaryColor,
                    ),
                    "h2": Style(
                      fontSize: FontSize(20.0),
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      color: AppColors.primaryColor,
                    ),
                    "p": Style(margin: Margins(bottom: Margin(10))),
                    "ul": Style(
                      padding: HtmlPaddings(left: HtmlPadding(5)),
                    ),
                    "li": Style(
                        margin: Margins(
                          bottom: Margin(5.0),
                        ),
                        listStyleType: ListStyleType.square),
                  },
                ),
              ),
              if (controller.isLoading.value) const LoadingScreen()
            ],
          ),
        ),
      ),
    );
  }
}
