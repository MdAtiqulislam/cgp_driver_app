/*
import 'dart:io';
import 'package:cgp_driver_app/common_widgets/custom_bottom_sheet.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';

var images = <XFile>[].obs;

void showDeliveryProofDialog(BuildContext parentContext) {
  showDialog(
    context: parentContext, // Use valid context
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.borderRadius.r),
                topRight: Radius.circular(AppDimensions.borderRadius.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.h,
                horizontal: AppDimensions.horizontalPadding.w,
              ),
              child: HeaderText(
                text: "Delivery Completed",
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          content: BodyText(
            text: "Do you want to capture a proof image?",
            maxLine: 10,
            size: 14,
          ),
          actions: <Widget>[
            MaterialButton(
              textColor: Colors.white,
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog
                XFile? image = await picImage(ImageSource.camera);
                if (image != null) {
                  images.add(image);
                  showCapturedImageBottomSheet(parentContext); // Show bottom sheet
                }
              },
              child: const Text("Yes"),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textColor: AppColors.primaryColor,
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: const Text("No"),
            ),
          ],
        ),
      );
    },
  );
}

void showCapturedImageBottomSheet(BuildContext context) {
  Get.bottomSheet(
    CustomBottomSheet(
      title: "Captured Proof",
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
              () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              images.isEmpty
                  ? const Text("No images captured.")
                  : SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(images[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text("Add More"),
                    onPressed: () async {
                      XFile? newImage = await picImage(ImageSource.camera);
                      if (newImage != null) {
                        images.add(newImage);
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload),
                    label: const Text("Upload"),
                    onPressed: () {
                      print("Uploading images: ${images.map((e) => e.path).toList()}");
                      Navigator.of(context).pop(); // Close bottom sheet after upload
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
*/

import 'dart:io';
import 'package:cgp_driver_app/common_widgets/custom_bottom_sheet.dart';
import 'package:cgp_driver_app/common_widgets/custom_snackbar.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';

var images = <XFile>[].obs;
var isLoading = false.obs;

void showDeliveryProofDialog(BuildContext parentContext, String deliveryId) {
  showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.borderRadius.r),
                topRight: Radius.circular(AppDimensions.borderRadius.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.h,
                horizontal: AppDimensions.horizontalPadding.w,
              ),
              child: HeaderText(
                text: "Delivery Completed",
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          content: BodyText(
            text: "Do you want to capture a proof image?",
            maxLine: 10,
            size: 14,
          ),
          actions: <Widget>[
            MaterialButton(
              textColor: Colors.white,
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                XFile? image = await picImage(ImageSource.camera);
                if (image != null) {
                  images.add(image);
                  showCapturedImageBottomSheet(parentContext, deliveryId);
                }
              },
              child: const Text("Yes"),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.primaryColor)),
              textColor: AppColors.primaryColor,
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("No"),
            ),
          ],
        ),
      );
    },
  );
}

void showCapturedImageBottomSheet(BuildContext context,String deliveryId) {
  Get.bottomSheet(
    CustomBottomSheet(
      title: "Captured Proof",
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  images.isEmpty
                      ? const Text("No images captured.")
                      : SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(images[index].path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        images.removeAt(
                                            index); // Remove the image
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.errorColor,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text("Add More"),
                        onPressed: () async {
                          XFile? newImage = await picImage(ImageSource.camera);
                          if (newImage != null) {
                            images.add(newImage);
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload),
                        label: const Text("Upload"),
                        onPressed: () async {
                          uploadImage(deliveryId);
                          //  Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              if (isLoading.value)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> uploadImage(String deliveryId) async {
  isLoading.value = true;
  List<File> imageFiles = images.map((xfile) => File(xfile.path)).toList();
  try {
    var response = await RemoteServices.uploadDeliveryProofImages(
        images: imageFiles,
        endPoint: "/api/v1/messaging/ajax/rider-image-upload",
        id: deliveryId);
    if (response != null) {
      Get.back();
      images.value = [];
      CustomSnackBar(msg: response['message'], isSuccess: true).showSnackBar();
    } else {
      CustomSnackBar(msg: AppStrings.httpErrorMSG.value, isSuccess: false)
          .showSnackBar();
    }
  } finally {
    isLoading.value = false;
  }
}
