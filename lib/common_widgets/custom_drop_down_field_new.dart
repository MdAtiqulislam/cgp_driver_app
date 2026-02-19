/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';

class CustomDropDownField extends StatelessWidget {
  final String? levelText;
  final String? title;
  final String? value;
  final bool? showBorder;
  final bool isRequired;
  final Color? bgColor;
  final int? itemIndex;
  final Function(String?)? onChange;
  final List<String> itemList;
  final String? Function(String?)? validator;
  final String? validatorText;

  const CustomDropDownField({
    required this.itemList,
    required this.onChange,
    this.isRequired = false,
    this.value,
    this.itemIndex,
    this.levelText,
    this.showBorder,
    this.bgColor,
    this.title,
    this.validator,
    this.validatorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BodyText(
              text: title!,
              size: 14,
              color: AppColors.levelTextColor,
            ),
          ),
        Center(
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  iconSize: 25,
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.white,
                  dropdownColor:
                  AppColors.scaffoldBgColor, // Dropdown menu background color
                  validator: validatorText != null
                      ? (value) {
                    if ((value ?? "").isEmpty) {
                      return validatorText;
                    }
                    return null;
                  }
                      : validator,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor:AppColors.textFieldBgColor,
                      errorMaxLines: 5,
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide:
                        const BorderSide(color: AppColors.primaryColorLight,width: .5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide:
                        const BorderSide(color: AppColors.primaryColorLight,),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide:
                        const BorderSide(color: AppColors.primaryColor,width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide:
                        const BorderSide(color: AppColors.errorColor),
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 24,
                          bottom: 16.h, // AppDimensions.widgetPaddingVer,
                          top: 16.h // AppDimensions.widgetPaddingVer
                      ),

                      labelText: isRequired ? "$levelText *" : levelText,
                      floatingLabelStyle: const TextStyle(
                          color: AppColors.headerTextColor,
                          fontWeight: FontWeight.bold),
                      hintStyle: const TextStyle(
                          color: Colors.white, fontSize: 16),
                      labelStyle: const TextStyle(
                          color: Colors.white, fontSize: 16),
                      errorStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.orange
                      )
                  ),

                  selectedItemBuilder: (BuildContext context) {
                    return itemList.map<Widget>((String item) {
                      return BodyText(
                        text: item,
                        maxLine: 1,
                        align: TextAlign.start,
                        color: Colors.white, // Selected item text color
                      );
                    }).toList();
                  },
                  items: itemList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0), // Margin for dropdown items
                            padding: const EdgeInsets.all(8.0), // Padding inside dropdown items
                            decoration: const BoxDecoration(
                              color: Colors.transparent, // Transparent to see the dropdown color
                            ),
                            child: BodyText(
                              text: value,
                              maxLine: 3,
                              align: TextAlign.start,
                              color: Colors.white,
                            ),
                          ),
                          Divider()
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: onChange,
                  value: value,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../utils/utils.dart';

class CustomDropDownFieldNew<T> extends StatelessWidget {
  final String? levelText;
  final String? title;
  final T? value;
  final bool? showBorder;
  final bool isRequired;
  final Color? bgColor;
  final int? itemIndex;
  final Function(T?)? onChange;
  final List<T> itemList;
  final String? Function(T?)? validator;
  final String? validatorText;
  final String Function(T) displayItem;

  const CustomDropDownFieldNew({
    required this.itemList,
    required this.onChange,
    required this.displayItem, // Function to display item as string
    this.isRequired = false,
    this.value,
    this.itemIndex,
    this.levelText,
    this.showBorder,
    this.bgColor,
    this.title,
    this.validator,
    this.validatorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BodyText(
              text: title!,
              size: 14,
              color: AppColors.bodyTextColor,
            ),
          ),
        Center(
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<T>(
                  isExpanded: true,
                  iconSize: 25,
                  iconEnabledColor: AppColors.primaryColor,
                  iconDisabledColor: AppColors.primaryColor,
                //  dropdownColor: AppColors.primaryColor,
                  validator: validatorText != null
                      ? (value) {
                    if (value == null || displayItem(value).isEmpty) {
                      return validatorText;
                    }
                    return null;
                  }
                      : validator,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),

                  decoration: inputDecoration(
                    levelText: levelText,
                    isRequired: isRequired,
                  ),


                  selectedItemBuilder: (BuildContext context) {
                    return itemList.map<Widget>((T item) {
                      return BodyText(
                        text: displayItem(item),
                        maxLine: 1,
                        align: TextAlign.start,
                        color: AppColors.headerTextColor,
                      );
                    }).toList();
                  },
                  items: itemList.map<DropdownMenuItem<T>>((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              //color: Colors.white,
                            ),
                            child: BodyText(
                              text: displayItem(value),
                              maxLine: 3,
                              align: TextAlign.start,
                              color: AppColors.headerTextColor,
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: onChange,
                  value: value,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
