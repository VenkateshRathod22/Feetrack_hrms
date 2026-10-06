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

class ProbationReportScreen extends StatefulWidget {
  const ProbationReportScreen({super.key});

  @override
  State<ProbationReportScreen> createState() => _ProbationReportScreenState();
}

class _ProbationReportScreenState extends State<ProbationReportScreen> {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String? employeeId;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport() {
    Get.find<ReportsController>().getProbationReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      "end_date": DateFormat('yyyy-MM-dd').format(endDate),
      if (employeeId != null) "employee_id": employeeId,
      if (searchController.text.isNotEmpty) "search": searchController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Probation Report", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.probationExport, search: _getSearchMap()),
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
                  decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none)),
                  onChanged: (v) => _fetchReport(),
                ),
              ),
              ReportFilterWidget(
                onFilterChanged: (empId, stat, start, end) {
                  setState(() {
                    employeeId = empId;
                    startDate = start;
                    endDate = end;
                  });
                  _fetchReport();
                },
              ),
              if (reportsController.isLoading && reportsController.probationReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: const CircularProgressIndicator())
              else ...[
                if (reportsController.probationReportSummary != null)
                  ReportSummaryWidget(items: [
                    ReportSummaryItemModel(
                        label: "Total Records",
                        value: reportsController.probationReportSummary!.totalRecords.toString(),
                        icon: Icons.badge_rounded),
                    ReportSummaryItemModel(
                        label: "On Probation",
                        value: (reportsController.probationReportSummary!.statusCounts?['on_probation'] ?? 0).toString(),
                        icon: Icons.timer_outlined),
                    ReportSummaryItemModel(
                        label: "Extended",
                        value: reportsController.probationReportSummary!.isExtendedCount.toString(),
                        icon: Icons.more_time_rounded),
                  ]),
                if (reportsController.probationReportList.isEmpty)
                  Padding(padding: EdgeInsets.only(top: 100.h), child: const Text("No data found"))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.r),
                    itemCount: reportsController.probationReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) => _buildCard(reportsController.probationReportList[index]),
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
          _infoRow(Icons.calendar_today, "Due: ${item.confirmationDueDate ?? "N/A"}"),
          _infoRow(Icons.event_available, "Confirmed: ${item.confirmationDate ?? "N/A"}"),
          if (item.isExtended == true) _infoRow(Icons.timer, "Extended to: ${item.extendedDueDate ?? "N/A"}"),
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
      decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(text?.replaceAll("_", " ")), style: TextStyle(fontSize: 10.sp, color: Colors.blue, fontWeight: FontWeight.bold)),
    );
  }
}
