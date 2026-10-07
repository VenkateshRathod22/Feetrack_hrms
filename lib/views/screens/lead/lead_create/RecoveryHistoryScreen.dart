import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/data/models/response/recovery_history_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';

class Recoveryhistoryscreen extends StatefulWidget {
  const Recoveryhistoryscreen({super.key});

  @override
  State<Recoveryhistoryscreen> createState() =>
      _RecoveryhistoryscreenState();
}

class _RecoveryhistoryscreenState extends State<Recoveryhistoryscreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeadController>().getLeadOrderRecoveryHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: Column(
          children: [
            CustomText(
              "Recovery History",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: blackText1,
              ),
            ),
            CustomText(
              "Track all payment collections",
              style: TextStyle(
                fontSize: 10.sp,
                color: greyText,
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<LeadController>(
        builder: (controller) {
          if (controller.isLoading &&
              controller.recoveryHistory.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                controller.getLeadOrderRecoveryHistory(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16.r,
                16.r,
                16.r,
                30.r,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.recoverySummary != null)
                    _buildSummarySection(
                      controller.recoverySummary!,
                    ),

                  sizedBoxHeight(height: 24),

                  _buildSectionHeader(
                    title: "Recovery Transactions",
                    count: controller.recoveryHistory.length,
                  ),

                  sizedBoxHeight(height: 14),

                  if (controller.recoveryHistory.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount:
                      controller.recoveryHistory.length,
                      separatorBuilder: (_, __) =>
                          sizedBoxHeight(height: 14),
                      itemBuilder: (context, index) {
                        return _buildRecoveryItem(
                          controller.recoveryHistory[index],
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // SUMMARY SECTION
  // ============================================================

  Widget _buildSummarySection(RecoverySummary summary) {
    return Column(
      children: [
        _buildTotalRecoveryCard(summary),

        sizedBoxHeight(height: 14),

        Row(
          children: [
            Expanded(
              child: _smallSummaryCard(
                title: "This Month",
                value: PriceConverter.convertToNumberFormat(
                  summary.thisMonthRecovered ?? 0,
                ),
                icon: Icons.calendar_month_rounded,
                color: Colors.blue,
              ),
            ),

            sizedBoxWidth(width: 12),

            Expanded(
              child: _smallSummaryCard(
                title: "Today",
                value: PriceConverter.convertToNumberFormat(
                  summary.todayRecovered ?? 0,
                ),
                icon: Icons.today_rounded,
                color: Colors.orange,
              ),
            ),
          ],
        ),

        sizedBoxHeight(height: 12),

        _buildTransactionCard(
          summary.totalTransactions ?? 0,
        ),
      ],
    );
  }

  Widget _buildTotalRecoveryCard(RecoverySummary summary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00A86B),
            Color(0xFF008F5B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58.r,
            width: 58.r,
            decoration: BoxDecoration(
              color: white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: white,
              size: 30.sp,
            ),
          ),

          sizedBoxWidth(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Total Recovery",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                sizedBoxHeight(height: 6),

                CustomText(
                  PriceConverter.convertToNumberFormat(
                    summary.totalRecovered ?? 0,
                  ),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.trending_up_rounded,
            color: white.withValues(alpha: 0.7),
            size: 28.sp,
          ),
        ],
      ),
    );
  }

  Widget _smallSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius:
                  BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18.sp,
                ),
              ),
            ],
          ),

          sizedBoxHeight(height: 14),

          CustomText(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: greyText,
            ),
          ),

          sizedBoxHeight(height: 4),

          CustomText(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: blackText1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(int transactions) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.r,
        vertical: 14.r,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: Colors.purple,
              size: 22.sp,
            ),
          ),

          sizedBoxWidth(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Total Transactions",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: greyText,
                  ),
                ),

                sizedBoxHeight(height: 3),

                CustomText(
                  "$transactions Transactions",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: blackText1,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            color: greyLight5,
            size: 16.sp,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader({
    required String title,
    required int count,
  }) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: blackText1,
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.r,
            vertical: 5.r,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius:
            BorderRadius.circular(20.r),
          ),
          child: CustomText(
            "$count Records",
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RECOVERY ITEM
  // ============================================================

  Widget _buildRecoveryItem(RecoveryHistoryItem item) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // TOP SECTION
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                _buildCustomerAvatar(
                  item.customer?.name,
                ),

                sizedBoxWidth(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        item.customer?.name ?? "Unknown Customer",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight:
                          FontWeight.bold,
                          color: blackText1,
                        ),
                      ),

                      sizedBoxHeight(height: 5),

                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 13.sp,
                            color: greyText,
                          ),

                          sizedBoxWidth(width: 4),

                          Expanded(
                            child: CustomText(
                              "Order #${item.orderNumber ?? 'N/A'}",
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: greyText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                sizedBoxWidth(width: 8),

                _buildAmountBadge(
                  item.amount ?? 0,
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: greyLight5.withValues(alpha: 0.5),
          ),

          // PAYMENT INFORMATION
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        icon: Icons.calendar_today_rounded,
                        label: "Payment Date",
                        value: item.paymentDate ?? "N/A",
                        color: Colors.blue,
                      ),
                    ),

                    sizedBoxWidth(width: 10),

                    Expanded(
                      child: _buildInfoTile(
                        icon:
                        Icons.account_balance_wallet_rounded,
                        label: "Payment Method",
                        value: capitalize(
                          item.paymentMethod,
                        ),
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),

                sizedBoxHeight(height: 12),

                _buildCollectorInfo(
                  item.collectedBy?.name ?? "N/A",
                ),

                if (item.orderFinancials != null) ...[
                  sizedBoxHeight(height: 14),

                  _buildFinancialSummary(
                    item.orderFinancials!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CUSTOMER AVATAR
  // ============================================================

  Widget _buildCustomerAvatar(String? name) {
    final String initial =
    (name != null && name.isNotEmpty)
        ? name[0].toUpperCase()
        : "?";

    return Container(
      height: 48.r,
      width: 48.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: CustomText(
        initial,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  // ============================================================
  // AMOUNT BADGE
  // ============================================================

  Widget _buildAmountBadge(num amount) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.r,
        vertical: 8.r,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.end,
        children: [
          CustomText(
            "Recovered",
            style: TextStyle(
              fontSize: 8.sp,
              color: green2,
            ),
          ),

          sizedBoxHeight(height: 2),

          CustomText(
            PriceConverter.convertToNumberFormat(amount),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: green2,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO TILE
  // ============================================================

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius:
              BorderRadius.circular(9.r),
            ),
            child: Icon(
              icon,
              size: 15.sp,
              color: color,
            ),
          ),

          sizedBoxWidth(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                CustomText(
                  label,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: greyText,
                  ),
                ),

                sizedBoxHeight(height: 2),

                CustomText(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight:
                    FontWeight.w600,
                    color: blackText2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COLLECTED BY
  // ============================================================

  Widget _buildCollectorInfo(String name) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.r,
        vertical: 10.r,
      ),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_rounded,
            color: Colors.purple,
            size: 18.sp,
          ),

          sizedBoxWidth(width: 8),

          CustomText(
            "Collected By",
            style: TextStyle(
              fontSize: 10.sp,
              color: greyText,
            ),
          ),

          const Spacer(),

          Flexible(
            child: CustomText(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FINANCIAL SUMMARY
  // ============================================================

  Widget _buildFinancialSummary(
      dynamic financials,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: backgroundLight,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          CustomText(
            "Order Financial Summary",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: blackText1,
            ),
          ),

          sizedBoxHeight(height: 12),

          Row(
            children: [
              Expanded(
                child: _financialItem(
                  "Total Amount",
                  financials.finalAmount,
                  color: Colors.blue,
                ),
              ),

              Container(
                height: 30.h,
                width: 1,
                color: greyLight5,
              ),

              Expanded(
                child: _financialItem(
                  "Paid",
                  financials.paidAmount,
                  color: Colors.green,
                ),
              ),

              Container(
                height: 30.h,
                width: 1,
                color: greyLight5,
              ),

              Expanded(
                child: _financialItem(
                  "Balance",
                  financials.remainingBalance,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _financialItem(
      String label,
      num? value, {
        required Color color,
      }) {
    return Column(
      children: [
        CustomText(
          label,
          style: TextStyle(
            fontSize: 8.sp,
            color: greyText,
          ),
        ),

        sizedBoxHeight(height: 4),

        CustomText(
          PriceConverter.convertToNumberFormat(
            value ?? 0,
          ),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 80.r,
              width: 80.r,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 38.sp,
                color: Colors.blue,
              ),
            ),

            sizedBoxHeight(height: 16),

            CustomText(
              "No Recovery Records",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: blackText1,
              ),
            ),

            sizedBoxHeight(height: 6),

            CustomText(
              "Recovery transactions will appear here",
              style: TextStyle(
                fontSize: 11.sp,
                color: greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


