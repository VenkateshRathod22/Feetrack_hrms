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

class ResignationExitReportScreen extends StatefulWidget {
  const ResignationExitReportScreen({super.key});

  @override
  State<ResignationExitReportScreen> createState() => _ResignationExitReportScreenState();
}

class _ResignationExitReportScreenState extends State<ResignationExitReportScreen> {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String? employeeId;
  String? status;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport() {
    Get.find<ReportsController>().getResignationExitReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      "end_date": DateFormat('yyyy-MM-dd').format(endDate),
      if (employeeId != null) "employee_id": employeeId,
      if (status != null) "status": status,
      if (searchController.text.isNotEmpty) "search": searchController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Resignation & Exit Report", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.resignationExitExport, search: _getSearchMap()),
            icon: const Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(hintText: "Search...", prefixIcon: const Icon(Icons.search), filled: true, fillColor: white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none)),
                  onChanged: (v) => _fetchReport(),
                ),
              ),
              ReportFilterWidget(
                onFilterChanged: (empId, stat, start, end) {
                  setState(() { employeeId = empId; status = stat; startDate = start; endDate = end; });
                  _fetchReport();
                },
              ),
              if (reportsController.isLoading && reportsController.resignationExitReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: const Center(child: CircularProgressIndicator()))
              else ...[
                if (reportsController.resignationExitReportSummary != null)
                  ReportSummaryWidget(items: [
                    ReportSummaryItemModel(
                        label: "Total Records",
                        value: reportsController.resignationExitReportSummary!.totalRecords.toString(),
                        icon: Icons.exit_to_app_rounded),
                    ReportSummaryItemModel(
                        label: "Serving Notice",
                        value: (reportsController.resignationExitReportSummary!.statusCounts?['serving_notice'] ?? 0).toString(),
                        icon: Icons.notification_important_rounded),
                    ReportSummaryItemModel(
                        label: "FNF Amount",
                        value: PriceConverter.convertToNumberFormat(reportsController.resignationExitReportSummary!.totalFnfAmount ?? 0),
                        icon: Icons.payments_rounded),
                    ReportSummaryItemModel(
                        label: "Pending FNF",
                        value: (reportsController.resignationExitReportSummary!.fnfCounts?['pending'] ?? 0).toString(),
                        icon: Icons.pending_rounded),
                  ]),
                if (reportsController.resignationExitReportList.isEmpty)
                  Padding(padding: EdgeInsets.only(top: 100.h), child: const Center(child: Text("No data found")))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.r),
                    itemCount: reportsController.resignationExitReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) => _buildCard(reportsController.resignationExitReportList[index]),
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCard(item) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CustomText(item.employeeName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
              _buildBadge(item.status),
            ],
          ),
          sizedBoxHeight(height: 8),
          _infoRow(Icons.calendar_today, "Resignation: ${item.resignationDate ?? "N/A"}"),
          _infoRow(Icons.event_available, "Last Day: ${item.lastWorkingDate ?? "N/A"}"),
          _infoRow(Icons.help_outline, "Reason: ${item.exitReason ?? "N/A"}"),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText("FNF Status: ${capitalize(item.fnfStatus)}", style: TextStyle(fontSize: 11.sp, color: greyText)),
              CustomText(PriceConverter.convertToNumberFormat(item.fnfAmount ?? 0), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(children: [Icon(icon, size: 14, color: grey), sizedBoxWidth(width: 8), Text(text, style: TextStyle(fontSize: 11.sp, color: greyDart2))]),
    );
  }

  Widget _buildBadge(String? text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(text?.replaceAll("_", " ")), style: TextStyle(fontSize: 10.sp, color: Colors.red, fontWeight: FontWeight.bold)),
    );
  }
}
