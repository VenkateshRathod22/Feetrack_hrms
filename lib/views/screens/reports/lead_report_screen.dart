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

class LeadReportScreen extends StatefulWidget {
  const LeadReportScreen({super.key});

  @override
  State<LeadReportScreen> createState() => _LeadReportScreenState();
}

class _LeadReportScreenState extends State<LeadReportScreen> {
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
    Get.find<ReportsController>().getLeadReport(search: _getSearchMap());
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
          "Lead Report",
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
                uri: AppConstants.leadExport,
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
                statusOptions: const ['new', 'interested', 'won', 'lost', 'rejected'],
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
              if (reportsController.isLoading && reportsController.leadReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.leadReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Leads",
                        value: reportsController.leadReportSummary!.totalLeads.toString(),
                        icon: Icons.leaderboard_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Won",
                        value: (reportsController.leadReportSummary!.statusCounts?['won'] ?? 0).toString(),
                        icon: Icons.emoji_events_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Interested",
                        value: (reportsController.leadReportSummary!.statusCounts?['interested'] ?? 0).toString(),
                        icon: Icons.thumbs_up_down_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "New",
                        value: (reportsController.leadReportSummary!.statusCounts?['new'] ?? 0).toString(),
                        icon: Icons.fiber_new_rounded,
                      ),
                    ],
                  ),
                if (reportsController.leadReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.leadReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final lead = reportsController.leadReportList[index];
                      return _buildLeadCard(context, lead);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLeadCard(BuildContext context, lead) {
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
                  child: CustomText(
                    lead.customerName ?? "N/A",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                  ),
                ),
                _buildStatusBadge(lead.status),
              ],
            ),
            sizedBoxHeight(height: 12),
            _infoRow(Icons.phone_rounded, "Mobile", lead.customerMobile ?? "N/A"),
            sizedBoxHeight(height: 6),
            _infoRow(Icons.person_outline_rounded, "Assigned", lead.assignedTo ?? "N/A"),
            sizedBoxHeight(height: 6),
            _infoRow(Icons.calendar_today_rounded, "Created", lead.createdAt ?? "N/A"),
            if (lead.notes != null && lead.notes!.isNotEmpty) ...[
              sizedBoxHeight(height: 8),
              const Divider(),
              sizedBoxHeight(height: 4),
              CustomText(
                "Notes: ${lead.notes}",
                style: TextStyle(fontSize: 11.sp, color: greyText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: grey),
        sizedBoxWidth(width: 8),
        CustomText("$label: ", style: TextStyle(fontSize: 11.sp, color: grey)),
        CustomText(value, style: TextStyle(fontSize: 11.sp, color: blackText1, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.blue;
    if (status?.toLowerCase() == 'won') color = Colors.green;
    if (status?.toLowerCase() == 'lost') color = Colors.red;
    if (status?.toLowerCase() == 'new') color = Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status?.replaceAll("_", " ")),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
