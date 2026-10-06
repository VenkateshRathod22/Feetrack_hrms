import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/reports/widget/report_filter_widget.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
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
    Get.find<ReportsController>().getExpenseReport(search: _getSearchMap());
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
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Expense Report",
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
                uri: AppConstants.expenseExport,
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
              ReportFilterWidget(
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
              if (reportsController.isLoading && reportsController.expenseReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.expenseReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Expenses",
                        value: reportsController.expenseReportSummary!.totalExpenses.toString(),
                        icon: Icons.receipt_long_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Total Amount",
                        value: PriceConverter.convertToNumberFormat(reportsController.expenseReportSummary!.totalAmount ?? 0),
                        icon: Icons.account_balance_wallet_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Approved",
                        value: reportsController.expenseReportSummary!.approved.toString(),
                        icon: Icons.check_circle_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Pending",
                        value: reportsController.expenseReportSummary!.pending.toString(),
                        icon: Icons.pending_actions_rounded,
                      ),
                    ],
                  ),
                if (reportsController.expenseReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.expenseReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final expense = reportsController.expenseReportList[index];
                      return _buildExpenseCard(context, expense);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildExpenseCard(BuildContext context, expense) {
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
                        expense.employeeName ?? "N/A",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                      ),
                      CustomText(
                        expense.category ?? "Expense",
                        style: TextStyle(fontSize: 11.sp, color: primaryColor, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(expense.status),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14.sp, color: greyText),
                    sizedBoxWidth(width: 8),
                    CustomText(
                      expense.date ?? "N/A",
                      style: TextStyle(fontSize: 12.sp, color: blackText1),
                    ),
                  ],
                ),
                CustomText(
                  PriceConverter.convertToNumberFormat(expense.amount ?? 0),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1),
                ),
              ],
            ),
            if (expense.description != null && expense.description!.isNotEmpty) ...[
              sizedBoxHeight(height: 8),
              const Divider(),
              sizedBoxHeight(height: 4),
              CustomText(
                "Desc: ${expense.description}",
                style: TextStyle(fontSize: 11.sp, color: greyDart2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.grey;
    if (status?.toLowerCase() == 'approved') color = Colors.green;
    if (status?.toLowerCase() == 'pending') color = Colors.orange;
    if (status?.toLowerCase() == 'rejected') color = Colors.red;

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
