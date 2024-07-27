import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../utils/utils.dart';

class CustomDropDownField extends StatelessWidget {
  final String? lavelText;
  final String? title;
  final Widget? preFix;
  final Widget? suffix;
  final bool isRequired;
  final String? hintText;
  final String? value;
  final bool? showBorder;
  final Color? bgColor;
  final int? itemIndex;
  final Function(String?)? onChange;
  final List<String> itemList;
  final String? Function(String?)? validator;
  final String? validatorText;

  const CustomDropDownField({
    required this.itemList,
    required this.onChange,
    this.value,
    this.suffix,
    this.hintText,
    this.preFix,
    this.isRequired=false,
    this.itemIndex,
    this.lavelText,
    this.showBorder,
    this.bgColor,
    this.title,
    this.validator,
    this.validatorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      iconSize: 25,
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(AppImagePath.dropdownIcon),
      ),
      iconEnabledColor: AppColors.primaryColor,
      iconDisabledColor: AppColors.primaryColor,
      selectedItemBuilder:   (_) {
      return itemList.map<Widget>((String item) {
        return Text(item);
      }).toList();
    },
      validator: validatorText != null
          ? (value) {
        if ((value ?? "").isEmpty) {
          return validatorText;
        }
        return null;
      }
          : validator,
      style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.bodyTextColor),
      decoration: inputDecoration(
        hintText: hintText,
        levelText: lavelText,
        isRequired: isRequired,
        preFix: preFix,
        suffix: suffix,
      ),
      items: itemList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BodyText(text: value,maxLine: 3,align: TextAlign.start,),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        if(onChange!=null){
          onChange!(value);
        }
      },
      value: value,
    );

  }
}
