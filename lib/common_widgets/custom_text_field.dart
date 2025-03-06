import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../utils/utils.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? validatorText;
  final TextInputType? textInputType;
  final String? title;
  final String? levelText;
  final Widget? preFix;
  final Widget? suffix;
  final String? hintText;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final bool? isEnable;
  final bool isRequired;
  final bool? isPassword;
  final bool? readonly;
  final Widget? trailing;
  final List<TextInputFormatter>? inputFormatter;
  final VoidCallback? trailingAction;
  final VoidCallback? onEditingCompleted;


  const CustomTextField(
      {this.controller,
      this.validator,
      this.validatorText,
      this.hintText,
      this.title,
      this.maxLine,
      this.minLine,
      this.isEnable,
      this.isPassword,
      this.readonly,
      this.textInputType,
      this.trailing,
      this.maxLength,
      this.preFix,
      this.suffix,
      this.isRequired = false,
      this.trailingAction,
      this.onEditingCompleted,
      this.inputFormatter,
      this.levelText,
      super.key});

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
              size: 12,
              color: AppColors.bodyTextColor,
            ),
          ),
        Center(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  clipBehavior: Clip.hardEdge,
                  inputFormatters: inputFormatter,
                  onEditingComplete: onEditingCompleted,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.bodyTextColor
                  ),
                  enabled: isEnable,
                  obscureText: isPassword ?? false,
                  obscuringCharacter: "*",
                  readOnly: readonly ?? false,
                  maxLines: maxLine ?? 1,
                  minLines: minLine ?? 1,
                  controller: controller,
                  validator: validatorText != null
                      ? (value) {
                          if ((value ?? "").isEmpty) {
                            return validatorText;
                          }
                          return null;
                        }
                      : validator,
                  maxLength: maxLength,
                  keyboardType: textInputType,// ?? TextInputType.name,
                  textAlignVertical: TextAlignVertical.center,
                  cursorWidth: .5,
                  decoration: inputDecoration(
                    hintText: hintText,
                    levelText: levelText,
                    isRequired: isRequired,
                    preFix: preFix,
                    suffix: suffix,
                  )
                ),
              ),
              if (trailing != null)
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    padding: EdgeInsets.only(
                        right: 16.w //AppDimensions.widgetPaddingHor
                        ),
                    icon: trailing!,
                    onPressed: trailingAction,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
