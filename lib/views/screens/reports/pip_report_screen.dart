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

class PipReportScreen extends StatefulWidget {
  const PipReportScreen({super.key});

  @override
  State<PipReportScreen> createState() => _PipReportScreenState();
}

class _PipReportScreenState extends State<PipReportScreen> {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String? employeeId;
  String? status;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getPipReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      if (employeeId != null) "employee_id": employeeId,
      if (status != null) "status": status,
      if (searchController.text.isNotEmpty) "search": searchController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText("PIP Report", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.pipExport, search: _getSearchMap()),
            icon:  Icon(Icons.download_rounded, color: primaryColor),
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
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  ),
                  onChanged: (v) => _fetchReport(),
                ),
              ),
              ReportFilterWidget(
                statusOptions: const ['under_review', 'completed', 'failed'],
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
              if (reportsController.isLoading && reportsController.pipReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: const CircularProgressIndicator())
              else ...[
                if (reportsController.pipReportSummary != null)
                  ReportSummaryWidget(items: [
                    ReportSummaryItemModel(label: "Total PIPs", value: reportsController.pipReportSummary!.totalPips.toString(), icon: Icons.trending_down_rounded),
                    ...reportsController.pipReportSummary!.statusCounts?.entries.map((e) => ReportSummaryItemModel(label: capitalize(e.key.replaceAll("_", " ")), value: e.value.toString(), icon: Icons.analytics_rounded)).toList() ?? [],
                  ]),
                if (reportsController.pipReportList.isEmpty)
                  Padding(padding: EdgeInsets.only(top: 100.h), child: Text("No data found"))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.r),
                    itemCount: reportsController.pipReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) => _buildPipCard(reportsController.pipReportList[index]),
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPipCard(pip) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CustomText(pip.employeeName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
              _buildStatusBadge(pip.status),
            ],
          ),
          sizedBoxHeight(height: 8),
          CustomText("Reason: ${pip.reason ?? "N/A"}", style: TextStyle(fontSize: 12.sp, color: greyDart2)),
          sizedBoxHeight(height: 4),
          CustomText("Targets: ${pip.improvementTargets ?? "N/A"}", style: TextStyle(fontSize: 12.sp, color: greyDart2)),
          sizedBoxHeight(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText("Start: ${pip.startDate ?? "N/A"}", style: TextStyle(fontSize: 11.sp, color: greyText)),
              CustomText("End: ${pip.endDate ?? "N/A"}", style: TextStyle(fontSize: 11.sp, color: greyText)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.orange;
    if (status == 'completed') color = Colors.green;
    if (status == 'failed') color = Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(status?.replaceAll("_", " ")), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
