import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../controllers/faq_page_controller.dart';

class FaqPageView extends GetView<FaqPageController> {
  final GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();

  FaqPageView({super.key});

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
        body: Obx(() {
          return Stack(
            children: [
              ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
                itemCount: controller.faqItems.length,
                itemBuilder: (context, index) {
                  final item = controller.faqItems[index];
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                        color: Colors.white,
                        boxShadow:  const [
                          BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 10
                          )
                        ]
                    ),
                    child: Material(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              // Icons.question_answer,
                              Icons.info_outline,
                              color: Colors.teal,
                            ),
                            title: Text(
                              item.question,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.teal[900],
                              ),
                            ),
                            trailing: Icon(
                              item.isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: Colors.teal,
                            ),
                            onTap: () {
                              controller.toggleFAQ(index);
                            },
                          ),
                          if (item.isExpanded)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.question_answer,
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.answer,
                                      style: TextStyle(
                                        color: Colors.teal[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: AppDimensions.widgetPadding.h,); },
              ),
              if(controller.isLoading.value)const LoadingScreen()
            ],
          );
        }),
      ),
    );
  }
}
