import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/custom_drop_down_field_new.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../controllers/support_controller.dart';
import '../models/issue_status_list_model.dart';

class SupportView extends GetView<SupportController> {
  final GlobalKey<FormState>formKey=GlobalKey<FormState>();
  final GlobalKey<ScaffoldState>scaffoldKey=GlobalKey<ScaffoldState>();

  SupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          minimal: false,
          scaffoldKey: scaffoldKey,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddSupportBottomSheet();
          },
          backgroundColor: AppColors.primaryColor,
          // Adjust color as needed
          tooltip: 'Add New Support',
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
        drawer: MyDrawer(),
        body: Obx(
              () {
            if ((controller.issueListModel.value.data?.data??[]).isEmpty) {
              return Stack(
                children: [
                  const Center(
                    child: Text('No support history available.'),
                  ),
                  if(controller.isLoading.value)const LoadingScreen()
                ],
              );
            }
            return Stack(
              children: [
                ListView.separated(

                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
                  itemCount: (controller.issueListModel.value.data?.data??[]).length,
                  itemBuilder: (context, index) {
                    final issue = controller.issueListModel.value.data?.data?[index];
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 10
                            )
                          ]
                      ),
                      child: ListTile(
                        title: Text(issue?.subject??""),
                        subtitle: Text(issue?.description??""),
                        leading: const Icon(Icons.support),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical:3.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                              color: AppColors.successColor
                          ),
                          child: BodyText(text: issue?.currentStatus?.name??"",color: Colors.white,),

                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: AppDimensions.contentPadding.h,);
                  },
                ),
                if(controller.isLoading.value)const LoadingScreen()
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAddSupportBottomSheet() {
    showCustomBottomSheet(
      title: "Customer support",
      content:  Obx(()=>Stack(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                const BodyText(
                  text:
                  "Please fill out the form below to request support. Our team will get back to you as soon as possible.",
                  maxLine: 10,
                  align: TextAlign.start,
                  size: 14,
                ),
                SizedBox(height: AppDimensions.sectionPadding.h,),

                CustomDropDownFieldNew<SingleIssueSubjectModel>(
                  levelText: "Status",
                  isRequired: true,
                  itemList: controller.issueSubjectListModel.value.data??[],
                  value: controller.issueSubjectListModel.value.data?.first??SingleIssueSubjectModel(),
                  onChange: (SingleIssueSubjectModel? newValue) {

                    controller. selectedStatus.value = newValue??SingleIssueSubjectModel();
                  },
                  displayItem: (SingleIssueSubjectModel status) => status.name??"",
                ),

                SizedBox(height: AppDimensions.widgetPadding.h,),
                CustomTextField(
                  levelText: "Description",
                  hintText: "Description",
                  maxLine: 10,
                  minLine: 2,
                  isRequired: true,
                  validatorText: "Required",
                  controller: controller.descriptionController,
                ),
                SizedBox(height: AppDimensions.sectionPadding.h,),
                AppButton(text: "Submit", onTap: (){
                  if(formKey.currentState?.validate()??false){
                    Get.back();
                    controller.addSupport();
                  }
                },bgColor: AppColors.primaryColor,),
                const SizedBox(height: AppDimensions.sectionPadding,)
              ],
            ),
          ),
          if(controller.isLoading.value)const Center(child: CircularProgressIndicator(),)
        ],
      )),
    );
  }
}