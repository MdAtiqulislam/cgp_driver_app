import 'dart:convert';

import 'package:cgp_driver_app/common_widgets/app_button.dart';
import 'package:cgp_driver_app/common_widgets/custom_check_box.dart';
import 'package:cgp_driver_app/common_widgets/custom_drop_down_field.dart';
import 'package:cgp_driver_app/common_widgets/custom_expanded_tile.dart';
import 'package:cgp_driver_app/common_widgets/custom_network_image.dart';
import 'package:cgp_driver_app/common_widgets/custom_phone_text_field.dart';
import 'package:cgp_driver_app/common_widgets/custom_ratings.dart';
import 'package:cgp_driver_app/common_widgets/empty_screen.dart';
import 'package:cgp_driver_app/common_widgets/vehicle_type_dropdown.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:cgp_driver_app/models/bank_info_model.dart';
import 'package:cgp_driver_app/models/single_vehicle_model.dart';
import 'package:cgp_driver_app/utils/enams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_circle_avatar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../../models/single_vehicle_type_model.dart';
import '../../statusSection/status_section.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  EditProfileView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _userInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bankInfoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              key: scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: scaffoldKey,
              ),
              drawer: MyDrawer(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: Column(children: [
                    StatusSection(
                      showOnlineStatus: false,
                      title: "Main Timeline",
                    ),
                    headerSection(),
                    SizedBox(
                      height: AppDimensions.sectionPadding.h,
                    ),
                    bodyContent(),
                  ]),
                ),
              ),
            ),
            if (controller.isLoading.value) const LoadingScreen()
          ],
        ),
      ),
    );
  }

  Widget headerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          ),
          child: Image.asset(
            "assets/images/slider_3.png",
            width: Get.width,
            height: 150.h,
            fit: BoxFit.cover,
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 60.h,
              // color: Colors.red,
            ),
            Positioned(
              left: AppDimensions.horizontalPadding.w,
              top: -30,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomCircleAvatar(
                    width: 80,
                    height: 80,
                    image: controller.rider.value.profileImageUrl ?? "",
                    localImage: AppImagePath.avatar,
                    bgColor: AppColors.primaryColor.withOpacity(.5),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Positioned(
              right: AppDimensions.horizontalPadding.w,
              top: AppDimensions.contentPadding.h,
              child: CustomRatingWidget(
                ratingValue: double.parse(
                    "${controller.rider.value.avgRating?.averageRating ?? 0}"),
                alignment: CrossAxisAlignment.end,
              )
              ,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.widgetPadding.w,
              vertical: AppDimensions.contentPadding.h),
          child: HeaderText(
              text: "${controller.rider.value.firstName ?? ""}"
                  " ${controller.rider.value.lastName ?? ""}"),
        )
      ],
    );
  }

  Widget bodyContent() {
    return Column(
      children: [
        CustomExpandedTile(
          title: "Personal Info",
          isExpanded: controller.isExpand[0],
          onExpansionChange: (value) {
            controller.isExpand[0] = value;
          },
          content: personalInfoSection(),
        ),
        CustomExpandedTile(
            isExpanded: controller.isExpand[1],
            title: "Vehicle info",
            onExpansionChange: (value) {
              controller.isExpand[1] = value;
            },
            content: controller.loadingVehicleInfo.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: BodyText(text: "Loading...\nPlease wait."),
                    ),
                  )
                : Column(
                    children: [
                      vehicleInfoSection(),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                      AppButton(
                        text: "Add New",
                        onTap: () {
                          controller.resetFields();
                          Get.bottomSheet(
                            isScrollControlled: true,
                            ignoreSafeArea: false,
                            addOrUpdateVehicle(action: "Add New"),
                          );
                        },
                        bgColor: AppColors.primaryColor,
                      )
                    ],
                  )),
        /*CustomExpandedTile(
            title: "Driving Preferences",
            isExpanded: controller.isExpand[2],
            onExpansionChange: (value) {
              controller.isExpand[2] = value;
            },
            content: personalInfoSection()),*/
        CustomExpandedTile(
            title: "Bank Info",
            isExpanded: controller.isExpand[2],
            onExpansionChange: (value) {
              controller.isExpand[2] = value;
            },
            content: controller.loadingBankInfo.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: BodyText(text: "Loading...\nPlease wait."),
                    ),
                  )
                : Column(
                    children: [
                      bankInfoSection(),
                      SizedBox(
                        height: AppDimensions.sectionPadding.h,
                      ),
                      AppButton(
                        text: "Add New",
                        onTap: () {
                          controller.resetFields();
                          Get.bottomSheet(
                            isScrollControlled: true,
                            ignoreSafeArea: false,
                            addOrUpdateBankInfo(action: "Add New"),
                          );
                        },
                        bgColor: AppColors.primaryColor,
                      )
                    ],
                  )),
      ],
    );
  }

  Widget personalInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
                text:
                    "${controller.rider.value.firstName ?? " "} ${controller.rider.value.lastName ?? " "}",
              ),
              BodyText(
                text: "Email: ${controller.rider.value.email ?? "N/A"}",
              ),
              BodyText(
                text: "Phone: 04${controller.rider.value.phone ?? "N/A"}",
              ),
              BodyText(
                text: "Gender: ${controller.rider.value.gender ?? "N/A"}",
              ),
              BodyText(
                text:
                    "Date of Birth: ${controller.rider.value.dateOfBirth ?? "N/A"}",
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            controller.base64ImageProfile.value = "";

            Get.bottomSheet(
              isScrollControlled: true,
              ignoreSafeArea: false,
              updatePersonalInfo(),
            );
          },
          icon: Image.asset(
            AppImagePath.editIcon,
            scale: 2,
          ),
        ),
      ],
    );
  }

  Widget vehicleInfoSection() {
    return (controller.riderVehicleModel.value.data ?? []).isEmpty
        ? const EmptyScreen(
            title: "You have not added any vehicle yet!",
            imageScaleFactor: 2,
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return singleVehicleCard(
                  vehicle: controller.riderVehicleModel.value.data?[index] ??
                      SingleVehicleModel());
            },
            separatorBuilder: (buildContext, index) {
              return const Divider();
            },
            itemCount: controller.riderVehicleModel.value.data?.length ?? 0);
  }

  Widget singleVehicleCard({required SingleVehicleModel vehicle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CustomCircleAvatar(
              width: 50,
              height: 50,
              image: vehicle.vehicleFrontImageUrl ?? "",
              localImage: AppImagePath.placeholderVehicle,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppDimensions.contentPadding.h),
              height: 5,
              color: AppColors.primaryColor,
              width: 40,
            ),
            CustomCircleAvatar(
              width: 50,
              height: 50,
              image: vehicle.vehicleBackImageUrl ?? "",
              localImage: AppImagePath.placeholderVehicle,
            ),
          ],
        ),
        SizedBox(
          width: AppDimensions.sectionPadding.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(
                text: vehicle.type?.name ?? "",
                color: AppColors.primaryColor,
              ),
              BodyText(text: "License Plate: ${vehicle.licensePlate ?? "N/A"}"),
              BodyText(text: "Brand: ${vehicle.brand ?? "N/A"}"),
              BodyText(text: "Model: ${vehicle.model ?? "N/A"}"),
              BodyText(
                  text: "Capacity: ${vehicle.type?.vehicleCapacity ?? ""}Ton"),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            controller.base64ImageProfile.value = "";
            controller.selectedVehicleModel.value = vehicle;
            controller.setVehicleData();
            Get.bottomSheet(
              isScrollControlled: true,
              ignoreSafeArea: false,
              addOrUpdateVehicle(action: "Update"),
            );
          },
          icon: Image.asset(
            AppImagePath.editIcon,
            scale: 2,
          ),
        ),
      ],
    );
  }

  Widget updatePersonalInfo() {
    return SafeArea(
      child: Container(
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.contentPadding.h),
              width: Get.width,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const HeaderText(
                    text: "Update Profile",
                    color: Colors.white,
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(AppImagePath.cancelIcon))
                ],
              ),
            ),
            Obx(
              () => Flexible(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.horizontalPadding.w),
                        child: Form(
                          key: _userInfoFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                              Stack(
                                children: [
                                  controller.base64ImageProfile.value.isEmpty
                                      ? CustomCircleAvatar(
                                          width: 100,
                                          height: 100,
                                          image: controller.rider.value
                                                  .profileImageUrl ??
                                              "",
                                          localImage: AppImagePath.avatar,
                                          bgColor: AppColors.primaryColor
                                              .withOpacity(.5),
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(1),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            clipBehavior: Clip.hardEdge,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.memory(
                                              base64Decode(controller
                                                  .base64ImageProfile.value),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.white54,
                                          onTap: () {
                                            // controller.chooseImage();

                                            Get.bottomSheet(choseImage(
                                                imageType:
                                                    ImageType.profile.name));
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      levelText: "First Name",
                                      hintText: "First Name",
                                      isRequired: true,
                                      validatorText: "Required",
                                      controller:
                                          controller.firstNameController,
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppDimensions.contentPadding.w,
                                  ),
                                  Expanded(
                                    child: CustomTextField(
                                      levelText: "Last Name",
                                      hintText: "Last Name",
                                      isRequired: true,
                                      validatorText: "Required",
                                      controller: controller.lastNameController,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              CustomPhoneTextField(
                                controller: controller.phoneController,
                              ),
                              /*CustomTextField(
                                levelText: "Phone/ Mobile",
                                hintText: "Phone/ Mobile",
                                isRequired: true,
                                validatorText: "Required",
                                textInputType: TextInputType.phone,
                                controller: controller.phoneController,
                              ),*/
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              CustomTextField(
                                levelText: "Email",
                                hintText: "Email",
                                isRequired: true,
                                validatorText: "Required",
                                textInputType: TextInputType.emailAddress,
                                controller: controller.emailController,
                              ),
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              CustomDropDownField(
                                  hintText: "Gender",
                                  lavelText: "Gender",
                                  isRequired: true,
                                  value:
                                      controller.selectedGender.toUpperCase(),
                                  itemList: controller.genders,
                                  onChange: (value) {
                                    controller.selectedGender = value ?? "";
                                  }),
                              /*   SizedBox(
                                    height: AppDimensions.contentPadding.h,
                                  ),
                                  CustomTextField(
                                    levelText: "Driving License Number",
                                    hintText: "Driving License Number",
                                    isRequired: true,
                                    validatorText: "Required",
                                    controller: controller
                                        .drivingLicenseController,
                                  ),*/
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              InkWell(
                                onTap: () {
                                  controller.selectDateOfBirth();
                                },
                                child: CustomTextField(
                                  levelText: "Date of Birth",
                                  hintText: "Date of Birth",
                                  isRequired: true,
                                  isEnable: false,
                                  validatorText: "Required",
                                  controller: controller.dateOfBirthController,
                                ),
                              ),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                              AppButton(
                                text: "Update",
                                onTap: () {
                                  if (_userInfoFormKey.currentState
                                          ?.validate() ??
                                      false) {
                                    controller.updateUser();
                                  } else {
                                    CustomSnackBar(
                                      msg:
                                          "All fields with '*' marks are required.",
                                      isSuccess: false,
                                    ).showSnackBar();
                                  }
                                },
                                bgColor: AppColors.primaryColor,
                              ),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (controller.isUpdating.value) const LoadingScreen()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addOrUpdateVehicle({required String action}) {
    return SafeArea(
      child: Container(
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.contentPadding.h),
              width: Get.width,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    text: "$action Vehicle",
                    color: Colors.white,
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(AppImagePath.cancelIcon))
                ],
              ),
            ),
            Obx(
              () => Flexible(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.horizontalPadding.w),
                        child: Form(
                          key: _userInfoFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        controller.base64ImageVehicleFront.value
                                                .isEmpty
                                            ? Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: AppColors
                                                            .primaryColor,
                                                        blurRadius: 10)
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimensions
                                                              .borderRadius.r),
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: double.infinity,
                                                  height: 180.h,
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppDimensions
                                                                .borderRadius
                                                                .r),
                                                  ),
                                                  child: CustomNetworkImage(
                                                    image: controller
                                                            .selectedVehicleModel
                                                            .value
                                                            .vehicleFrontImageUrl ??
                                                        "",
                                                    fit: BoxFit.contain,
                                                    localImage: AppImagePath
                                                        .placeholderVehicle,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                width: double.infinity,
                                                height: 180.h,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimensions
                                                              .borderRadius.r),
                                                ),
                                                child: Image.memory(
                                                  base64Decode(controller
                                                      .base64ImageVehicleFront
                                                      .value),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                        SizedBox(
                                          height: AppDimensions.widgetPadding.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.bottomSheet(
                                              isScrollControlled: true,
                                              ignoreSafeArea: false,
                                              choseImage(
                                                  cropStyle:
                                                      CropStyle.rectangle,
                                                  imageType: ImageType
                                                      .vehicleFront.name),
                                            );
                                          },
                                          child: SizedBox(
                                            height: 80,
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const Expanded(
                                                      child: HeaderText(
                                                        text:
                                                            "Upload vehicle front image with number plate",
                                                        color: AppColors
                                                            .primaryColor,
                                                        maxLine: 3,
                                                        size: 12,
                                                        resizeable: false,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: AppDimensions
                                                          .contentPadding.w,
                                                    ),
                                                    const Icon(
                                                      Icons
                                                          .cloud_upload_outlined,
                                                      color: AppColors
                                                          .primaryColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: AppDimensions.widgetPadding.w),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        controller.base64ImageVehicleBack.value
                                                .isEmpty
                                            ? Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: AppColors
                                                            .primaryColor,
                                                        blurRadius: 10)
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimensions
                                                              .borderRadius.r),
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: double.infinity,
                                                  height: 180.h,
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppDimensions
                                                                .borderRadius
                                                                .r),
                                                  ),
                                                  child: CustomNetworkImage(
                                                    image: controller
                                                            .selectedVehicleModel
                                                            .value
                                                            .vehicleBackImageUrl ??
                                                        "",
                                                    fit: BoxFit.contain,
                                                    localImage: AppImagePath
                                                        .placeholderVehicle,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                width: double.infinity,
                                                height: 180.h,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimensions
                                                              .borderRadius.r),
                                                ),
                                                child: Image.memory(
                                                  base64Decode(controller
                                                      .base64ImageVehicleBack
                                                      .value),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                        SizedBox(
                                          height: AppDimensions.widgetPadding.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.bottomSheet(
                                              isScrollControlled: true,
                                              ignoreSafeArea: false,
                                              choseImage(
                                                  cropStyle:
                                                      CropStyle.rectangle,
                                                  imageType: ImageType
                                                      .vehicleBack.name),
                                            );
                                          },
                                          child: SizedBox(
                                            height: 80,
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const Expanded(
                                                      child: HeaderText(
                                                        text:
                                                            "Upload vehicle back image",
                                                        color: AppColors
                                                            .primaryColor,
                                                        maxLine: 3,
                                                        size: 12,
                                                        resizeable: false,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: AppDimensions
                                                          .contentPadding.w,
                                                    ),
                                                    const Icon(
                                                      Icons
                                                          .cloud_upload_outlined,
                                                      color: AppColors
                                                          .primaryColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                              VehicleTypeDropDownField(
                                labelText: "Vehicle Type",
                                hintText: "Vehicle Type",
                                itemList:
                                    controller.vehicleTypeModel.value.data ??
                                        [],
                                onChange: (SingleVehicleTypeModel? value) {
                                  controller.selectedVehicleType =
                                      value ?? SingleVehicleTypeModel();
                                },
                                value: (controller.selectedVehicleType.id ?? "")
                                        .isEmpty
                                    ? null
                                    : controller.selectedVehicleType,
                              ),
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              CustomTextField(
                                levelText: "Make",
                                hintText: "Make",
                                isRequired: true,
                                validatorText: "Required",
                                controller: controller.brandController,
                              ),
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              CustomTextField(
                                levelText: "Model",
                                hintText: "Model",
                                isRequired: true,
                                validatorText: "Required",
                                controller: controller.modelController,
                              ),
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              /*CustomTextField(
                                levelText: "Make",
                                hintText: "Make",
                                isRequired: true,
                                validatorText: "Required",
                                controller: controller.makeController,
                              ),
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),*/
                              CustomTextField(
                                levelText: "Vehicle Registration Number",
                                hintText: "Vehicle Registration Number",
                                isRequired: true,
                                validatorText: "Required",
                                controller: controller.licencePlateController,
                              ),
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              CustomDropDownField(
                                  hintText: "Year",
                                  lavelText: "Year",
                                  isRequired: true,
                                  value: controller.selectedYear,
                                  itemList: controller.yearList,
                                  onChange: (value) {
                                    controller.selectedYear = value ?? "";
                                  }),
                              SizedBox(
                                height: AppDimensions.contentPadding.h,
                              ),
                              if (action == "Add New")
                                AppButton(
                                  text: "Add new vehicle",
                                  onTap: () {
                                    if (_userInfoFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      controller.addNewVehicle();
                                    } else {
                                      CustomSnackBar(
                                        msg:
                                            "All fields with '*' marks are required.",
                                        isSuccess: false,
                                      ).showSnackBar();
                                    }
                                  },
                                  bgColor: AppColors.primaryColor,
                                ),
                              if (action == "Update")
                                AppButton(
                                  text: "Update",
                                  onTap: () {
                                    if (_userInfoFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      controller.updateVehicle();
                                    } else {
                                      CustomSnackBar(
                                        msg:
                                            "All fields with '*' marks are required.",
                                        isSuccess: false,
                                      ).showSnackBar();
                                    }
                                  },
                                  bgColor: AppColors.primaryColor,
                                ),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (controller.isUpdating.value) const LoadingScreen()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget choseImage({CropStyle? cropStyle, required String imageType}) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.r),
          topLeft: Radius.circular(15.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 32.h,
          ),
          const HeaderText(
            text: "Select an action",
            color: AppColors.primaryColor,
            size: 18,
          ),
          SizedBox(height: 32.h //AppDimensions.widgetPaddingVer,
              ),
          const Divider(
            thickness: 5,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 32.h // AppDimensions.contentPaddingVer,
              ),
          Container(
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Material(
              child: InkWell(
                onTap: () {
                  controller.selectImage(
                      source: ImageSource.camera,
                      cropStyle: cropStyle,
                      imageType: imageType);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w, // AppDimensions.horizontalPadding,
                      vertical: 24.h // AppDimensions.widgetPaddingVer
                      ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImagePath.cameraIcon,
                        height: 40.h,
                      ),
                      SizedBox(width: 24.w // AppDimensions.widgetPaddingHor,
                          ),
                      const HeaderText(text: "Open Camera"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          // SizedBox(height: Dimensions.widgetPaddingVer,),
          Container(
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Material(
              child: InkWell(
                onTap: () {
                  controller.selectImage(
                      source: ImageSource.gallery,
                      cropStyle: cropStyle,
                      imageType: imageType);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w, // AppDimensions.horizontalPadding,
                      vertical: 24.w //AppDimensions.widgetPaddingVer
                      ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImagePath.galleryIcon,
                        height: 40.h,
                      ),
                      SizedBox(width: 16.w // AppDimensions.widgetPaddingHor,
                          ),
                      const HeaderText(text: "Open Gallery"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h //AppDimensions.sectionPaddingVer,
              )
        ],
      ),
    );
  }

  Widget addOrUpdateBankInfo({required String action}) {
    return SafeArea(
      child: Container(
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.contentPadding.h),
              width: Get.width,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    text: "$action Bank Info",
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(AppImagePath.cancelIcon),
                  ),
                ],
              ),
            ),
            Obx(
              () => Flexible(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.horizontalPadding.w),
                        child: Form(
                          key: _bankInfoFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                              CustomTextField(
                                levelText: "Account Number",
                                hintText: "Account Number",
                                isRequired: true,
                                controller:
                                    controller.bankAccountNumberController,
                              ),
                              SizedBox(
                                height: AppDimensions.widgetPadding.h,
                              ),
                              CustomTextField(
                                levelText: "BSB",
                                hintText: "BSB",
                                isRequired: true,
                                controller: controller.bankBSBController,
                              ),
                              SizedBox(
                                height: AppDimensions.widgetPadding.h,
                              ),
                              CustomTextField(
                                levelText: "Account Name",
                                hintText: "Account Name",
                                isRequired: true,
                                controller:
                                    controller.bankAccountHolderNameController,
                              ),
                              SizedBox(
                                height: AppDimensions.widgetPadding.h,
                              ),
                              CustomCheckBox(
                                  padding: EdgeInsets.zero,
                                  value: controller.isDefaultBank.value,
                                  title: const HeaderText(
                                    text: "Make as default",
                                    color: AppColors.primaryColor,
                                  ),
                                  onChanged: (value) {
                                    controller.isDefaultBank.value =
                                        !controller.isDefaultBank.value;
                                  }),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                              if (action == "Add New")
                                AppButton(
                                  text: "Add",
                                  onTap: () {
                                    if (_bankInfoFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      controller.addNewBankDetails();
                                    } else {
                                      CustomSnackBar(
                                        msg:
                                            "All fields with '*' marks are required.",
                                        isSuccess: false,
                                      ).showSnackBar();
                                    }
                                  },
                                  bgColor: AppColors.primaryColor,
                                ),
                              if (action == "Update")
                                AppButton(
                                  text: "Update",
                                  onTap: () {
                                    if (_bankInfoFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      controller.updateBank();
                                    } else {
                                      CustomSnackBar(
                                        msg:
                                            "All fields with '*' marks are required.",
                                        isSuccess: false,
                                      ).showSnackBar();
                                    }
                                  },
                                  bgColor: AppColors.primaryColor,
                                ),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (controller.isUpdating.value) const LoadingScreen()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bankInfoSection() {
    return (controller.bankHistoryModel.value.data ?? []).isEmpty
        ? const EmptyScreen(
            title: "You have not added any Bank yet!",
            imageScaleFactor: 2,
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return singleBankCard(
                  bank: controller.bankHistoryModel.value.data?[index] ??
                      BankInfoModel());
            },
            separatorBuilder: (buildContext, index) {
              return const Divider();
            },
            itemCount: controller.bankHistoryModel.value.data?.length ?? 0);
  }

  Widget singleBankCard({required BankInfoModel bank}) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: (bank.isDefault ?? false)
                    ? Colors.green.shade100
                    : Colors.white,
                blurRadius: 10)
          ],
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          color: Colors.white),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bank.isDefault ?? false)
                  Padding(
                    padding:
                        EdgeInsets.only(top: AppDimensions.contentPadding.h),
                    child: const Icon(
                      Icons.circle,
                      size: 15,
                      color: AppColors.successColor,
                    ),
                  ),
                SizedBox(
                  width: AppDimensions.contentPadding.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          HeaderText(text: bank.accountHolderName ?? ""),
                          if (bank.verifiedAt != null)
                            const Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 14,
                            )
                        ],
                      ),
                      BodyText(
                        text: "AC No.: ${bank.accountNumber ?? ""}",
                        size: 12,
                        maxLine: 5,
                        align: TextAlign.start,
                      ),
                      BodyText(
                        text: "BSB: ${bank.bsb ?? ""}",
                        size: 12,
                        maxLine: 5,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.selectedBank.value = bank;
                    controller.setBankData();
                    Get.bottomSheet(
                      isScrollControlled: true,
                      ignoreSafeArea: false,
                      addOrUpdateBankInfo(action: "Update"),
                    );
                  },
                  icon: Image.asset(
                    AppImagePath.editIcon,
                    scale: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
