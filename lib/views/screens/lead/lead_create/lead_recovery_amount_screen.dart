import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/data/models/response/lead_recovery_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_order_recovery_paynow_screen.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';

class LeadRecoveryAmountScreen extends StatefulWidget {
  const LeadRecoveryAmountScreen({super.key});

  @override
  State<LeadRecoveryAmountScreen> createState() => _LeadRecoveryAmountScreenState();
}

class _LeadRecoveryAmountScreenState extends State<LeadRecoveryAmountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeadController>().getLeadOrderRecovery();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Lead Order Recovery",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: const AppBarBackButton(),
      ),
      body: GetBuilder<LeadController>(builder: (controller) {
        if (controller.isLoading && controller.pendingRecoveries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.getLeadOrderRecovery(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                if (controller.pendingRecoverySummary != null) 
                  _buildSummaryCards(controller.pendingRecoverySummary!),
                sizedBoxHeight(height: 20),
                if (controller.pendingRecoveries.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: CustomText("No pending recoveries found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.pendingRecoveries.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                    itemBuilder: (context, index) {
                      return _buildRecoveryItem(controller.pendingRecoveries[index]);
                    },
                  ),
                sizedBoxHeight(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards(RecoveryListSummary summary) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            "Outstanding", 
            PriceConverter.convertToNumberFormat(summary.totalOutstanding ?? 0), 
            Colors.red
          ),
        ),
        sizedBoxWidth(width: 12),
        Expanded(
          child: _summaryCard(
            "Pending Orders", 
            summary.totalPendingOrders?.toString() ?? "0", 
            Colors.orange
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText, fontWeight: FontWeight.w500)),
          sizedBoxHeight(height: 4),
          CustomText(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildRecoveryItem(LeadRecoveryItem item) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        item.orderNumber ?? "#ORDER",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => navigate(context: context, page: LeadOrderRecoveryPaynowScreen(recoveryItem: item)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green2,
                        foregroundColor: white,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        elevation: 0,
                      ),
                      child: CustomText("Pay Now", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: white)),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: secondaryColor.withValues(alpha: 0.1),
                      child: Icon(Icons.person_outline, color: secondaryColor, size: 20.sp),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(item.customer?.name ?? "N/A", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
                          CustomText(item.customer?.mobile ?? "", style: TextStyle(fontSize: 11.sp, color: greyText)),
                        ],
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: backgroundLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _financialDetail("Total", item.financials?.finalAmount),
                      _financialDetail("Paid", item.financials?.paidAmount),
                      _financialDetail("Balance", item.financials?.remainingBalance, isRed: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (item.lastPayment != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: greyLight4.withValues(alpha: 0.3),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
              ),
              child: Row(
                children: [
                  Icon(Icons.history_rounded, size: 14.sp, color: greyText),
                  sizedBoxWidth(width: 6),
                  Expanded(
                    child: CustomText(
                      "Last payment of ${PriceConverter.convertToNumberFormat(item.lastPayment!.amount ?? 0)} via ${item.lastPayment!.paymentMethod?.toUpperCase()} on ${item.lastPayment!.paymentDate}",
                      style: TextStyle(fontSize: 10.sp, color: greyText),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _financialDetail(String label, num? value, {bool isRed = false}) {
    return Column(
      children: [
        CustomText(label, style: TextStyle(fontSize: 9.sp, color: greyText)),
        CustomText(
          PriceConverter.convertToNumberFormat(value ?? 0), 
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isRed ? red : blackText2)
        ),
      ],
    );
  }

  void _showPaymentDialog(LeadRecoveryItem item) {
    // Placeholder for payment collection logic
    showToast(message: "Payment collection for ${item.orderNumber} is coming soon", toastType: ToastType.info);
  }
}
