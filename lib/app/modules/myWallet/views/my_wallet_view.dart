import 'package:cgp_driver_app/app/modules/myWallet/controllers/my_wallet_controller.dart';
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/common_widgets/custom_loading_screen.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constraints/app_colors.dart';

class MyWalletView extends GetView<MyWalletController> {
  MyWalletView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: scaffoldKey,
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(

          child: Obx(()=>Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.sectionPadding.h,),
                    _buildBalanceSection(),
                    const SizedBox(height: 20),
                    _buildLastTransactionSection(),
                    const SizedBox(height: 20),
                    _buildTransactionHistorySection(),
                  ],
                ),
              ),
              if(controller.isLoading.value)const LoadingScreen()
            ],
          ),),
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, AppColors.infoColor],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Balance',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          HeaderText(
            text: "${(controller.paymentHistory.value.data?.currentBalance ?? 0)
                .toStringAsFixed(2)} AUD", color: Colors.white, size: 36,),
          const Divider(color: Colors.white54, height: 20, thickness: 1),
          const Text(
            'Today\'s Earnings',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          HeaderText(text:
          '${(controller.todaysEarning.value.data?.totalEarnings ?? 0)} AUD',
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildLastTransactionSection() {
    if (controller.paymentHistory.value.data?.lastSettlementAmount == null) {
      return const Text('No transactions available.');
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last Transaction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          HeaderText(text: "${(controller.paymentHistory.value.data
              ?.lastSettlementAmount ?? 0).toStringAsFixed(2)} AUD",color: AppColors.successColor,)
        ],
      ),
    );
  }

  Widget _buildTransactionHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.paymentHistory.value.data?.paymentHistory
              ?.length ?? 0,
          itemBuilder: (context, index) {
            final transaction = controller.paymentHistory.value.data
                ?.paymentHistory?[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (transaction?.transactionType ?? "") == "debit" ? const Icon(
                    Icons.arrow_upward, color: AppColors.errorColor,) : const Icon(
                    Icons.arrow_downward, color: AppColors.successColor,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction?.paymentFor??"",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatDateTime(dateTimeString: (transaction?.paidAt??DateTime.now()).toString()),
                        style:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),



                  Text(
                    '${(transaction?.transactionType ?? "") == "debit"
                        ? "-"
                        : "+" }  ${(transaction?.netBalance ?? 0)
                    }',
                    style: TextStyle(
                      fontSize: 16,
                      color: (transaction?.transactionType ?? "") == "debit"
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
