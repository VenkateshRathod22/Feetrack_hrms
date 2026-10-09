import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/reports/widget/report_staff_filter_widget.dart';

class SalaryReportScreen extends StatefulWidget {
  const SalaryReportScreen({super.key});

  @override
  State<SalaryReportScreen> createState() => _SalaryReportScreenState();
}

class _SalaryReportScreenState extends State<SalaryReportScreen> {
  String search = "";
  String? departmentId;
  String? roleId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport() {
    Get.find<ReportsController>().getSalaryReport(search: _getSearchMap());
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
          "Salary Management Report",
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
                uri: AppConstants.salaryExport,
                search: _getSearchMap(),
              );
            },
            icon: Icon(Icons.download_rounded, color: primaryColor),
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
              if (reportsController.isLoading && reportsController.salaryReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.salaryReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Records",
                        value: reportsController.salaryReportSummary!.totalRecords.toString(),
                        icon: Icons.assignment_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Gross Pay",
                        value: PriceConverter.convertToNumberFormat(reportsController.salaryReportSummary!.totalGrossPay ?? 0),
                        icon: Icons.payments_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Deductions",
                        value: PriceConverter.convertToNumberFormat(reportsController.salaryReportSummary!.totalDeductions ?? 0),
                        icon: Icons.money_off_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Net Pay",
                        value: PriceConverter.convertToNumberFormat(reportsController.salaryReportSummary!.totalNetPay ?? 0),
                        icon: Icons.account_balance_wallet_rounded,
                      ),
                    ],
                  ),
                if (reportsController.salaryReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.salaryReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final salary = reportsController.salaryReportList[index];
                      return _buildSalaryCard(context, salary);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSalaryCard(BuildContext context, salary) {
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
                        salary.employeeName ?? "N/A",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                      ),
                      CustomText(
                        salary.employeeEmail ?? "N/A",
                        style: TextStyle(fontSize: 11.sp, color: grey),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(salary.status),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailItem("Month", "${salary.month}/${salary.year}", primaryColor),
                _detailItem("Net Pay", PriceConverter.convertToNumberFormat(salary.netPay ?? 0), Colors.green),
              ],
            ),
            sizedBoxHeight(height: 12),
            const Divider(),
            sizedBoxHeight(height: 8),
            _breakdownRow("Basic Salary", salary.basicSalary ?? 0),
            _breakdownRow("Allowances", salary.allowances ?? 0),
            _breakdownRow("Bonuses", salary.bonuses ?? 0),
            _breakdownRow("Commissions", salary.commissions ?? 0),
            _breakdownRow("Deductions", salary.deductions ?? 0, isNegative: true),
            sizedBoxHeight(height: 8),
            const Divider(),
            sizedBoxHeight(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 CustomText("Gross Pay", style: TextStyle(fontWeight: FontWeight.bold, color: blackText1)),
                CustomText(
                  PriceConverter.convertToNumberFormat(salary.grossPay ?? 0),
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 13.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _breakdownRow(String label, num amount, {bool isNegative = false}) {
    if (amount == 0 && !isNegative) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, style: TextStyle(fontSize: 11.sp, color: greyDart2)),
          CustomText(
            "${isNegative ? "-" : ""}${PriceConverter.convertToNumberFormat(amount)}",
            style: TextStyle(fontSize: 11.sp, color: isNegative ? Colors.red : blackText1, fontWeight: FontWeight.w500),
          ),
        ],
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
