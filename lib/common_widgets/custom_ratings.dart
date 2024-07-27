import 'package:cgp_driver_app/constraints/body_text.dart';
import 'package:flutter/material.dart';

class CustomRatingWidget extends StatelessWidget {
  final double ratingValue;
  final double starSize;
  final double textSize;
  final CrossAxisAlignment alignment;

  const CustomRatingWidget({super.key, required this.ratingValue,this.starSize=14,this.textSize=10,this.alignment=CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    // Calculate full and half stars
    int fullStars = ratingValue.floor();
    bool hasHalfStar = ratingValue - fullStars >= 0.5;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            if (index < fullStars) {
              // Full orange star
              return Icon(Icons.star, color: Colors.orange,size: starSize,);
            } else if (index == fullStars && hasHalfStar) {
              // Half orange star
              return Icon(Icons.star_half, color: Colors.orange,size: starSize,);
            } else {
              // Empty gray star
              return Icon(Icons.star_border, color: Colors.grey,size: starSize,);
            }
          }),
        ),
        BodyText(text: 'Ratings: ${ratingValue.toStringAsFixed(1)}',size: textSize,),
      ],
    );
  }
}
