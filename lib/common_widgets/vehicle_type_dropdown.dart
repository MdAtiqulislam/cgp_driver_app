import 'package:cgp_driver_app/common_widgets/custom_network_image.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/models/single_vehicle_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../utils/utils.dart';

class VehicleTypeDropDownField extends StatelessWidget {
  final String? labelText;
  final String? title;
  final Widget? preFix;
  final Widget? suffix;
  final bool isRequired;
  final String? hintText;
  final SingleVehicleTypeModel? value;
  final bool? showBorder;
  final Color? bgColor;
  final int? itemIndex;
  final Function(SingleVehicleTypeModel?)? onChange;
  final List<SingleVehicleTypeModel> itemList;
  final String? Function(SingleVehicleTypeModel?)? validator;
  final String? validatorText;

  const VehicleTypeDropDownField({
    required this.itemList,
    required this.onChange,
    this.value,
    this.suffix,
    this.hintText,
    this.preFix,
    this.isRequired=false,
    this.itemIndex,
    this.labelText,
    this.showBorder,
    this.bgColor,
    this.title,
    this.validator,
    this.validatorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SingleVehicleTypeModel>(

      isExpanded: true,
      iconSize: 25,
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(AppImagePath.dropdownIcon),
      ),
      iconEnabledColor: AppColors.primaryColor,
      iconDisabledColor: AppColors.primaryColor,
      selectedItemBuilder:   (_) {
        return itemList.map<Widget>((SingleVehicleTypeModel item) {
          return Text(item.name??"");
        }).toList();
      },
      validator: validatorText != null
          ? (value) {
        if ((value?.name??"").isEmpty) {
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
        levelText: labelText,
        isRequired: isRequired,
        preFix: preFix,
        suffix: suffix,
      ),
      items: itemList.map<DropdownMenuItem<SingleVehicleTypeModel>>((SingleVehicleTypeModel value) {
        return DropdownMenuItem<SingleVehicleTypeModel>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 60,
                       // height: 40,
                        child: CustomNetworkImage(
                          image: value.mediaUrl??"",
                          fit: BoxFit.contain,
                        ),
                    ),
                    SizedBox(width: AppDimensions.contentPadding.w,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyText(text: value.name??"",maxLine: 3,align: TextAlign.start,size: 14,),
                        BodyText(text: "Capacity:${value.vehicleCapacity??""}",maxLine: 3,align: TextAlign.start,size: 12,),
                      ],
                    ),)
                  ],
                ),
                const Divider()
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (SingleVehicleTypeModel? value) {
        if(onChange!=null){
          onChange!(value);
        }
      },
      value: value,
    );

  }
}
