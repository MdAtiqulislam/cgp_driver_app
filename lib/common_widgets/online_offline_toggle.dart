import 'package:cgp_driver_app/constraints/app_colors.dart';
import 'package:cgp_driver_app/constraints/app_strings.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:flutter/material.dart';

class OnlineOfflineToggle extends StatelessWidget {
  final bool isOnline;
  final Function(bool) onChanged;

  const OnlineOfflineToggle({super.key,

    required this.isOnline,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isOnline);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: 140.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isOnline ? AppColors.primaryColor : AppColors.inactiveColor,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
              left: isOnline ? 105.0 : 5.0,
              top: -10,
              bottom: -10,
              child: Container(
                padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:isOnline? Colors.white:Colors.grey.shade300
                  ),
                  child: Image.asset(AppImagePath.deliveryVanOutline,height: 20,width: 20,)),
            ),
            Center(child: HeaderText(text: isOnline?"Online":"Offline",color:isOnline? Colors.white:Colors.grey.shade300,resizeable: false,))
          ],
        ),
      ),
    );
  }
}
