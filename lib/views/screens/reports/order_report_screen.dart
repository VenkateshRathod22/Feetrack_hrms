import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/reports/widget/report_filter_widget.dart';

class OrderReportScreen extends StatefulWidget {
  const OrderReportScreen({super.key});

  @override
  State<OrderReportScreen> createState() => _OrderReportScreenState();
}

class _OrderReportScreenState extends State<OrderReportScreen> {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String? employeeId;
  String? status;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getOrderReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      "end_date": DateFormat('yyyy-MM-dd').format(endDate),
      if (employeeId != null) "employee_id": employeeId,
      if (status != null) "status": status,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Order Report",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Get.find<ReportsController>().exportReport(
                uri: AppConstants.orderExport,
                search: _getSearchMap(),
              );
            },
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ReportFilterWidget(
                statusOptions: const ['paid', 'unpaid', 'partial'],
                onFilterChanged: (empId, stat, start, end) {
                  setState(() {
                    employeeId = empId;
                    status = stat;
                    startDate = start;
                    endDate = end;
                  });
                  _fetchReport();
                },
              ),
              if (reportsController.isLoading && reportsController.orderReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.orderReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Orders",
                        value: reportsController.orderReportSummary!.totalOrders.toString(),
                        icon: Icons.shopping_bag_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Total Amount",
                        value: PriceConverter.convertToNumberFormat(reportsController.orderReportSummary!.totalFinalAmount ?? 0),
                        icon: Icons.payments_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Pending Approvals",
                        value: (reportsController.orderReportSummary!.approvalCounts?['pending'] ?? 0).toString(),
                        icon: Icons.pending_actions_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Paid Orders",
                        value: (reportsController.orderReportSummary!.paymentCounts?['paid'] ?? 0).toString(),
                        icon: Icons.check_circle_rounded,
                      ),
                    ],
                  ),
                if (reportsController.orderReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.orderReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final order = reportsController.orderReportList[index];
                      return _buildOrderCard(context, order);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, order) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        order.customerName ?? "N/A",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                      ),
                      CustomText(
                        "Code: ${order.employeeCode ?? "N/A"}",
                        style: TextStyle(fontSize: 11.sp, color: grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildStatusBadge(order.paymentStatus),
                    if (order.currentStage != null) ...[
                      sizedBoxHeight(height: 4),
                      _buildStageBadge(order.currentStage),
                    ],
                  ],
                ),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailItem("Total", PriceConverter.convertToNumberFormat(order.finalAmount ?? 0), Colors.blue),
                _detailItem("Paid", PriceConverter.convertToNumberFormat(order.paidAmount ?? 0), Colors.green),
                _detailItem("Balance", PriceConverter.convertToNumberFormat(order.remainingBalance ?? 0), Colors.red),
              ],
            ),
            sizedBoxHeight(height: 12),
            const Divider(),
            sizedBoxHeight(height: 4),
            Row(
              children: [
                Icon(Icons.person_outline_rounded, size: 14.sp, color: grey),
                sizedBoxWidth(width: 4),
                CustomText("Assigned: ${order.assignedTo ?? "N/A"}", style: TextStyle(fontSize: 11.sp, color: greyText)),
                const Spacer(),
                Icon(Icons.calendar_today_rounded, size: 12.sp, color: grey),
                sizedBoxWidth(width: 4),
                CustomText(order.createdAt?.split(" ")[0] ?? "N/A", style: TextStyle(fontSize: 11.sp, color: greyText)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
        sizedBoxHeight(height: 2),
        CustomText(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }


  Widget _summaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style:  TextStyle(fontSize: 10, color: greyDart2)),
        CustomText(value, style:  TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryColor)),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.grey;
    if (status?.toLowerCase() == 'paid') color = Colors.green;
    if (status?.toLowerCase() == 'partial') color = Colors.orange;
    if (status?.toLowerCase() == 'unpaid') color = Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        capitalize(status),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStageBadge(String? stage) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        capitalize(stage),
        style: TextStyle(fontSize: 10.sp, color: primaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
