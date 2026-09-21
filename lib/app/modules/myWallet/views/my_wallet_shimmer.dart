import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import '../../../../constraints/app_colors.dart';

class WalletShimmer extends StatelessWidget {
  const WalletShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Balance Section Placeholder
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.infoColor],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 18, width: 120, color: Colors.white),
                  const SizedBox(height: 10),
                  Container(height: 36, width: 180, color: Colors.white),
                  const SizedBox(height: 10),
                  Container(height: 18, width: 150, color: Colors.white),
                  const SizedBox(height: 10),
                  Container(height: 28, width: 120, color: Colors.white),
                  const SizedBox(height: 20),
                  Container(height: 40, width: double.infinity, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Last Transaction Placeholder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 18, width: 150, color: Colors.white),
                  Container(height: 18, width: 80, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Transaction History Placeholder
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height: 18, width: 20, color: Colors.white),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 16, width: 120, color: Colors.white),
                          const SizedBox(height: 5),
                          Container(height: 14, width: 80, color: Colors.white),
                        ],
                      ),
                      Container(height: 16, width: 50, color: Colors.white),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}