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

class TaskReportScreen extends StatefulWidget {
  const TaskReportScreen({super.key});

  @override
  State<TaskReportScreen> createState() => _TaskReportScreenState();
}

class _TaskReportScreenState extends State<TaskReportScreen> {
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
    Get.find<ReportsController>().getTaskReport(search: _getSearchMap());
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
          "Task Report",
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
                uri: AppConstants.taskExport,
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
              ReportFilterWidget(
                statusOptions: const ['pending', 'in_progress', 'completed', 'cancelled'],
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
              if (reportsController.isLoading && reportsController.taskReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.taskReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Tasks",
                        value: reportsController.taskReportSummary!.totalTasks.toString(),
                        icon: Icons.task_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Pending",
                        value: (reportsController.taskReportSummary!.statusCounts?['pending'] ?? 0).toString(),
                        icon: Icons.pending_actions_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Completed",
                        value: (reportsController.taskReportSummary!.statusCounts?['completed'] ?? 0).toString(),
                        icon: Icons.task_alt_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "In Progress",
                        value: (reportsController.taskReportSummary!.statusCounts?['in_progress'] ?? 0).toString(),
                        icon: Icons.sync_rounded,
                      ),
                    ],
                  ),
                if (reportsController.taskReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.taskReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final task = reportsController.taskReportList[index];
                      return _buildTaskCard(context, task);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTaskCard(BuildContext context, task) {
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
                    task.title ?? "N/A",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                  ),
                ),
                _buildStatusBadge(task.status),
              ],
            ),
            sizedBoxHeight(height: 12),
            _infoRow(Icons.person_outline_rounded, "Assigned", task.employeeName ?? "N/A"),
            sizedBoxHeight(height: 6),
            _infoRow(Icons.event_note_rounded, "Due Date", task.dueDate ?? "N/A"),
            if (task.description != null && task.description!.isNotEmpty) ...[
              sizedBoxHeight(height: 8),
              const Divider(),
              sizedBoxHeight(height: 4),
              CustomText(
                task.description!,
                style: TextStyle(fontSize: 11.sp, color: greyText),
                maxLines: 2,
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
    Color color = Colors.grey;
    if (status?.toLowerCase() == 'completed') color = Colors.green;
    if (status?.toLowerCase() == 'pending') color = Colors.orange;
    if (status?.toLowerCase() == 'in_progress') color = Colors.blue;

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
