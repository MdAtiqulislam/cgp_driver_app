
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/app_colors.dart';
import '../constraints/dimensions.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const CustomRadioListTile({super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        //color: Colors.red,
        borderRadius: BorderRadius.circular(5.r)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(value),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
            child: Row(
              children: [
                _customRadioButton,
                 SizedBox(width: AppDimensions.contentPadding.w),
                if (title != null) title,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF4E4E4E),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.primaryColor: null,
          ),

        ),
      ),
    );
  }
}