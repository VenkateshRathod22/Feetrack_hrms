import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/reports/widget/report_staff_filter_widget.dart';

class RecoveryReportScreen extends StatefulWidget {
  const RecoveryReportScreen({super.key});

  @override
  State<RecoveryReportScreen> createState() => _RecoveryReportScreenState();
}

class _RecoveryReportScreenState extends State<RecoveryReportScreen> {
  String search = "";
  String? departmentId;
  String? roleId;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getRecoveryReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      if (search.isNotEmpty) "search": search,
      if (departmentId != null) "department_id": departmentId,
      if (roleId != null) "role_id": roleId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Recovery Report",
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
                uri: AppConstants.recoveryExport,
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
              ReportStaffFilterWidget(
                onFilterChanged: (s, d, r) {
                  setState(() {
                    search = s;
                    departmentId = d;
                    roleId = r;
                  });
                  _fetchReport();
                },
              ),
              if (reportsController.isLoading && reportsController.recoveryReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.recoveryReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Orders",
                        value: reportsController.recoveryReportSummary!.totalOrders.toString(),
                        icon: Icons.assignment_return_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Total Amount",
                        value: PriceConverter.convertToNumberFormat(reportsController.recoveryReportSummary!.totalAmount ?? 0),
                        icon: Icons.payments_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Total Paid",
                        value: PriceConverter.convertToNumberFormat(reportsController.recoveryReportSummary!.totalPaid ?? 0),
                        icon: Icons.check_circle_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Remaining",
                        value: PriceConverter.convertToNumberFormat(reportsController.recoveryReportSummary!.totalRemaining ?? 0),
                        icon: Icons.warning_amber_rounded,
                      ),
                    ],
                  ),
                if (reportsController.recoveryReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.recoveryReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final recovery = reportsController.recoveryReportList[index];
                      return _buildRecoveryCard(context, recovery);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRecoveryCard(BuildContext context, recovery) {
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
                        recovery.customerName ?? "N/A",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                      ),
                      CustomText(
                        "Order ID: ${recovery.orderId ?? "N/A"}",
                        style: TextStyle(fontSize: 11.sp, color: grey),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(recovery.paymentStatus),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailItem("Total", PriceConverter.convertToNumberFormat(recovery.totalAmount ?? 0), Colors.blue),
                _detailItem("Paid", PriceConverter.convertToNumberFormat(recovery.paidAmount ?? 0), Colors.green),
                _detailItem("Balance", PriceConverter.convertToNumberFormat(recovery.remainingBalance ?? 0), Colors.red),
              ],
            ),
            sizedBoxHeight(height: 12),
            const Divider(),
            sizedBoxHeight(height: 4),
            Row(
              children: [
                Icon(Icons.person_outline_rounded, size: 14.sp, color: grey),
                sizedBoxWidth(width: 4),
                CustomText("By: ${recovery.employeeName ?? "N/A"}", style: TextStyle(fontSize: 11.sp, color: greyText)),
                const Spacer(),
                Icon(Icons.calendar_today_rounded, size: 12.sp, color: grey),
                sizedBoxWidth(width: 4),
                CustomText(recovery.createdAt?.split(" ")[0] ?? "N/A", style: TextStyle(fontSize: 11.sp, color: greyText)),
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

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.grey;
    if (status?.toLowerCase() == 'paid') color = Colors.green;
    if (status?.toLowerCase() == 'partial') color = Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
