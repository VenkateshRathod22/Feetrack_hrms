import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/reports/widget/report_staff_filter_widget.dart';

class CommissionReportScreen extends StatefulWidget {
  const CommissionReportScreen({super.key});

  @override
  State<CommissionReportScreen> createState() => _CommissionReportScreenState();
}

class _CommissionReportScreenState extends State<CommissionReportScreen> {
  String search = "";
  String? departmentId;
  String? roleId;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getCommissionReport(search: _getSearchMap());
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
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Commission Report",
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
                uri: AppConstants.commissionExport,
                search: _getSearchMap(),
              );
            },
            icon: const Icon(Icons.download_rounded, color: primaryColor),
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
              if (reportsController.isLoading && reportsController.commissionReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.commissionReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Records",
                        value: reportsController.commissionReportSummary!.totalRecords.toString(),
                        icon: Icons.assignment_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Comm. Earned",
                        value: PriceConverter.convertToNumberFormat(reportsController.commissionReportSummary!.totalCommissionEarned ?? 0),
                        icon: Icons.percent_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Recov. Earned",
                        value: PriceConverter.convertToNumberFormat(reportsController.commissionReportSummary!.totalRecoveryEarned ?? 0),
                        icon: Icons.assignment_return_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Net Payout",
                        value: PriceConverter.convertToNumberFormat(reportsController.commissionReportSummary!.totalNetPayout ?? 0),
                        icon: Icons.account_balance_wallet_rounded,
                      ),
                    ],
                  ),
                if (reportsController.commissionReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.commissionReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final commission = reportsController.commissionReportList[index];
                      return _buildCommissionCard(context, commission);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCommissionCard(BuildContext context, commission) {
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
                        commission.employeeName ?? "N/A",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                      ),
                      CustomText(
                        "ID: ${commission.employeeCode ?? "N/A"}",
                        style: TextStyle(fontSize: 11.sp, color: grey),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(commission.status),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailItem("Commission", PriceConverter.convertToNumberFormat(commission.commissionEarned ?? 0), primaryColor),
                _detailItem("Recovery", PriceConverter.convertToNumberFormat(commission.recoveryEarned ?? 0), Colors.orange),
                _detailItem("Net Payout", PriceConverter.convertToNumberFormat(commission.netPayout ?? 0), Colors.green),
              ],
            ),
            sizedBoxHeight(height: 12),
            const Divider(),
            sizedBoxHeight(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "Period: ${commission.month}/${commission.year}",
                  style: TextStyle(fontSize: 11.sp, color: greyText),
                ),
                CustomText(
                  "Date: ${commission.createdAt?.split(" ")[0] ?? "N/A"}",
                  style: TextStyle(fontSize: 11.sp, color: greyText),
                ),
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
        CustomText(label, style: TextStyle(fontSize: 9.sp, color: greyText)),
        sizedBoxHeight(height: 2),
        CustomText(value, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = status?.toLowerCase() == 'paid' ? Colors.green : Colors.orange;
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
