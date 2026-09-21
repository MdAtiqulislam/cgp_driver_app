/*

import 'package:cgp_driver_app/app/modules/myWallet/controllers/my_wallet_controller.dart';
import 'package:cgp_driver_app/common_widgets/custom_app_bar.dart';
import 'package:cgp_driver_app/common_widgets/my_drawer.dart';
import 'package:cgp_driver_app/constraints/dimensions.dart';
import 'package:cgp_driver_app/constraints/header_text.dart';
import 'package:cgp_driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../constraints/app_colors.dart';
import 'my_wallet_shimmer.dart';

class MyWalletView extends GetView<MyWalletController> {
  MyWalletView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: scaffoldKey),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Obx(
            () => controller.isLoading.value
                ? const WalletShimmer()
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.horizontalPadding.w,
                        vertical: AppDimensions.verticalPadding.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //SizedBox(height: AppDimensions.sectionPadding.h),
                        _buildBalanceSection(),
                        const SizedBox(height: 20),
                        _buildLastTransactionSection(),
                        const SizedBox(height: 20),
                        _buildTransactionHistorySection(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// =========================
  /// 🔥 BALANCE SECTION
  /// =========================
  Widget _buildBalanceSection() {
    final data = controller.paymentHistory.value.data;

    final balance = data?.currentBalance ?? 0;
    final isRequestPending = data?.withdrawRequest ?? false;

    final canWithdraw = balance >= 50 && !isRequestPending;

    return Container(
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
          const Text(
            'Current Balance',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),

          HeaderText(
            text: "${balance.toStringAsFixed(2)} AUD",
            color: Colors.white,
            size: 36,
          ),

          const Divider(color: Colors.white54, height: 20),

          const Text(
            'Today\'s Earnings',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),

          HeaderText(
            text:
                '${(controller.todaysEarning.value.data?.totalEarnings ?? 0)} AUD',
            color: Colors.white,
            size: 28,
          ),

          const SizedBox(height: 20),

          /// 🔥 FINAL STATE HANDLING
          if (controller.isLoading.value)
            SizedBox.shrink()
          else if (isRequestPending)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Your withdrawal request is pending",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            )
          else if (canWithdraw)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _onWithdrawPressed(balance);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Withdraw",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Minimum withdrawal amount is 50 AUD",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  /// =========================
  /// 🔥 WITHDRAW ACTION
  /// =========================
  void _onWithdrawPressed(double balance) {
    if (balance < 50) {
      Get.snackbar(
        "Withdraw Not Available",
        "Minimum withdrawal amount is 50 AUD",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    /// 👉 TODO: Replace with API call / BottomSheet
    Get.snackbar(
      "Success",
      "Withdraw request initiated",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  /// =========================
  /// LAST TRANSACTION
  /// =========================
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
        children: [
          const Text(
            'Last Transaction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          HeaderText(
            text:
                "${(controller.paymentHistory.value.data?.lastSettlementAmount ?? 0).toStringAsFixed(2)} AUD",
            color: AppColors.successColor,
          )
        ],
      ),
    );
  }

  /// =========================
  /// TRANSACTION HISTORY
  /// =========================
  Widget _buildTransactionHistorySection() {
    final list = controller.paymentHistory.value.data?.paymentHistory ?? [];

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
          itemCount: list.length,
          itemBuilder: (context, index) {
            final transaction = list[index];

            final isDebit = transaction.transactionType == "debit";

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
                  Icon(
                    isDebit ? Icons.arrow_upward : Icons.arrow_downward,
                    color:
                        isDebit ? AppColors.errorColor : AppColors.successColor,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.paymentFor ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatDateTime(
                          dateTimeString:
                              (transaction.paidAt ?? DateTime.now()).toString(),
                        ),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    '${isDebit ? "-" : "+"} ${transaction.netBalance ?? 0}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDebit ? Colors.red : Colors.green,
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
*/

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
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_check_box.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import 'my_wallet_shimmer.dart';

class MyWalletView extends GetView<MyWalletController> {
  MyWalletView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _bankInfoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: scaffoldKey),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Obx(
            () => controller.isLoading.value
                ? const WalletShimmer()
                :Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                    vertical: AppDimensions.verticalPadding.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBalanceSection(),
                      const SizedBox(height: 20),
                      _buildLastTransactionSection(),
                      const SizedBox(height: 20),
                      _buildTransactionHistorySection(),
                    ],
                  ),
                ),
                if(controller.loadingBankInfo.value)LoadingScreen()

              ],
            ),
          ),
        ),
      ),
    );
  }

  /// =========================
  /// 🔥 BALANCE SECTION
  /// =========================
  Widget _buildBalanceSection() {
    final data = controller.paymentHistory.value.data;

    final balance = data?.currentBalance ?? 0;
    final isRequestPending = data?.withdrawRequest ?? false;
    final canWithdraw = balance >= 50 && !isRequestPending;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.9),
            AppColors.infoColor
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet,
                  color: Colors.white, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Current Balance',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          HeaderText(
            text: "${balance.toStringAsFixed(2)} AUD",
            color: Colors.white,
            size: 36,
          ),
          const Divider(color: Colors.white54, height: 20),
          Row(
            children: [
              const Icon(Icons.attach_money, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text(
                "Today's Earnings",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          HeaderText(
            text:
                '${(controller.todaysEarning.value.data?.totalEarnings ?? 0)} AUD',
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(height: 20),

          /// 🔥 FINAL STATE HANDLING
          if (controller.isLoading.value)
            SizedBox.shrink()
          else if (isRequestPending)
            _buildStatusMessage(
                "Your withdrawal request is pending", Colors.orange)
          else if (canWithdraw)
            _buildWithdrawButton(balance)
          else
            _buildStatusMessage("Minimum withdrawal amount is 50 AUD",
                Colors.white.withOpacity(0.2)),
        ],
      ),
    );
  }

  Widget _buildWithdrawButton(double balance) {
    return GestureDetector(
      onTap: () => _onWithdrawPressed(balance),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          "Withdraw",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessage(String message, Color bgColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// =========================
  /// 🔥 WITHDRAW ACTION
  /// =========================
  void _onWithdrawPressed(double balance) {
    if (balance < 50) {
      Get.snackbar(
        "Withdraw Not Available",
        "Minimum withdrawal amount is 50 AUD",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    controller.getBankInfo().then((value){
      if((controller.bankHistoryModel.value.data??[]).isEmpty){
        Get.bottomSheet(
          isScrollControlled: true,
          ignoreSafeArea: false,
          addNewBankInfo(action: "Add New Bank Details"),
        );
      }else{
        Get.bottomSheet(
          isScrollControlled: true,
          ignoreSafeArea: false,
          _buildBankList(action: "Select Bank Details"),
        );
      }
    });
  }

  /// =========================
  /// LAST TRANSACTION
  /// =========================
  Widget _buildLastTransactionSection() {
    if (controller.paymentHistory.value.data?.lastSettlementAmount == null) {
      return const Text('No transactions available.');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Last Transaction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          HeaderText(
            text:
                "${(controller.paymentHistory.value.data?.lastSettlementAmount ?? 0).toStringAsFixed(2)} AUD",
            color: AppColors.successColor,
          )
        ],
      ),
    );
  }

  /// =========================
  /// TRANSACTION HISTORY
  /// =========================
  Widget _buildTransactionHistorySection() {
    final list = controller.paymentHistory.value.data?.paymentHistory ?? [];

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
          itemCount: list.length,
          itemBuilder: (context, index) {
            final transaction = list[index];
            final isDebit = transaction.transactionType == "debit";

            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    isDebit ? Icons.arrow_upward : Icons.arrow_downward,
                    color:
                        isDebit ? AppColors.errorColor : AppColors.successColor,
                  ),
                  title: Text(
                    transaction.paymentFor ?? "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    formatDateTime(
                      dateTimeString:
                          (transaction.paidAt ?? DateTime.now()).toString(),
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Text(
                    '${isDebit ? "-" : "+"} ${transaction.netBalance ?? 0}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDebit ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(), // 🔥 Divider separates each transaction
              ],
            );
          },
        )
      ],
    );
  }

  Widget addNewBankInfo({required String action}) {
    return SafeArea(
      child: Container(
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.contentPadding.h),
              width: Get.width,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    text: action,
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(AppImagePath.cancelIcon),
                  ),
                ],
              ),
            ),
            Obx(
                  () => Flexible(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.horizontalPadding.w),
                        child: Form(
                          key: _bankInfoFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                              CustomTextField(
                                levelText: "Account Number",
                                hintText: "Account Number",
                                isRequired: true,
                                controller:
                                controller.bankAccountNumberController,
                              ),
                              SizedBox(
                                height: AppDimensions.widgetPadding.h,
                              ),
                              CustomTextField(
                                levelText: "BSB",
                                hintText: "BSB",
                                isRequired: true,
                                controller: controller.bankBSBController,
                              ),
                              SizedBox(
                                height: AppDimensions.widgetPadding.h,
                              ),
                              CustomTextField(
                                levelText: "Account Name",
                                hintText: "Account Name",
                                isRequired: true,
                                controller:
                                controller.bankAccountHolderNameController,
                              ),
                              SizedBox(
                                height: AppDimensions.widgetPadding.h,
                              ),
                              CustomCheckBox(
                                  padding: EdgeInsets.zero,
                                  value: controller.isDefaultBank.value,
                                  title: const HeaderText(
                                    text: "Make as default",
                                    color: AppColors.primaryColor,
                                  ),
                                  onChanged: (value) {
                                    controller.isDefaultBank.value =
                                    !controller.isDefaultBank.value;
                                  }),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              ),
                                AppButton(
                                  text: "Add",
                                  onTap: () {
                                    if (_bankInfoFormKey.currentState
                                        ?.validate() ??
                                        false) {
                                      controller.addNewBankDetails();
                                    } else {
                                      CustomSnackBar(
                                        msg:
                                        "All fields with '*' marks are required.",
                                        isSuccess: false,
                                      ).showSnackBar();
                                    }
                                  },
                                  bgColor: AppColors.primaryColor,
                                ),
                              SizedBox(
                                height: AppDimensions.sectionPadding.h,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (controller.loadingBankInfo.value) const LoadingScreen()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankList({required String action}) {

    return SafeArea(
      child: Container(
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding.w,
                vertical: AppDimensions.contentPadding.h,
              ),
              width: Get.width,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    text: action,
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(AppImagePath.cancelIcon),
                  ),
                ],
              ),
            ),

            /// ✅ ONLY ONE OBX
            Flexible(

              child: Obx(()=>Stack(
                children: [
                  ListView.separated(
                    itemCount: controller.bankHistoryModel.value.data?.length??0,//bankList.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final bank = controller.bankHistoryModel.value.data?[index];
                      final isSelected=controller.bankHistoryModel.value.data?[index].isDefault??false;

                      return InkWell(
                        onTap: () {
                          /// 🔥 CONFIRM DIALOG
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text("Confirm Payment Account"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Are you sure you want to receive payment to this account?",
                                    style: TextStyle(fontSize: 14),
                                  ),

                                  const SizedBox(height: 12),

                                  /// 🔥 BANK DETAILS CARD
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bank?.accountHolderName ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        Text("A/C: ${bank?.accountNumber ?? ""}"),
                                        Text("BSB: ${bank?.bsb ?? ""}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.selectedBankId.value = (bank?.id).toString();
                                    Get.back();
                                    controller.makePaymentRequest(bankDetails:bank);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  child: const Text("Confirm", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimensions.verticalPadding.h,
                            horizontal: AppDimensions.horizontalPadding.w,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(0.05)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_balance,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bank?.accountHolderName ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "BSB: ${bank?.bsb ?? ""}",
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (controller.loadingBankInfo.value)
                    const LoadingScreen(),
                ],
              ),)
            ),
          ],
        ),
      ),
    );
  }
}
