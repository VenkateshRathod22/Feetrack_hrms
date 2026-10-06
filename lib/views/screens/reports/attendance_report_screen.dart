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

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport() {
    Get.find<ReportsController>().getAttendanceReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      "end_date": DateFormat('yyyy-MM-dd').format(endDate),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Attendance Report",
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
                uri: AppConstants.attendanceExport,
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
              _buildDateFilter(context),
              if (reportsController.isLoading && reportsController.attendanceReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.attendanceReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Records",
                        value: reportsController.attendanceReportSummary!.totalRecords.toString(),
                        icon: Icons.calendar_month_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Present",
                        value: reportsController.attendanceReportSummary!.present.toString(),
                        icon: Icons.check_circle_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Late Records",
                        value: reportsController.attendanceReportSummary!.lateRecords.toString(),
                        icon: Icons.history_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Missed Punch",
                        value: reportsController.attendanceReportSummary!.missedPunch.toString(),
                        icon: Icons.warning_amber_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Total Hours",
                        value: reportsController.attendanceReportSummary!.totalHours ?? "0h 0m",
                        icon: Icons.access_time_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Productive Hrs",
                        value: reportsController.attendanceReportSummary!.productiveHours ?? "0h 0m",
                        icon: Icons.timer_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Overtime Hrs",
                        value: reportsController.attendanceReportSummary!.overtimeHours ?? "0h 0m",
                        icon: Icons.more_time_rounded,
                      ),
                    ],
                  ),
                if (reportsController.attendanceReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.attendanceReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final attendance = reportsController.attendanceReportList[index];
                      return _buildAttendanceCard(context, attendance);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, attendance) {
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      attendance.employeeName ?? "N/A",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                    ),
                    CustomText(
                      _formatDate(attendance.date),
                      style: TextStyle(fontSize: 11.sp, color: grey),
                    ),
                  ],
                ),
                _buildStatusBadge(attendance.status),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailItem("Punch In", attendance.checkIn ?? "--:--", Icons.login_rounded, Colors.green),
                _detailItem("Punch Out", attendance.checkOut ?? "--:--", Icons.logout_rounded, Colors.red),
                _detailItem("Total", attendance.totalHours ?? "0h 0m", Icons.access_time_rounded, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 12.sp, color: color),
            sizedBoxWidth(width: 4),
            CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
          ],
        ),
        sizedBoxHeight(height: 4),
        CustomText(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: blackText1)),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildDateFilter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: InkWell(
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            initialDateRange: DateTimeRange(start: startDate, end: endDate),
          );
          if (picked != null) {
            setState(() {
              startDate = picked.start;
              endDate = picked.end;
            });
            _fetchReport();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: greyLight1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_rounded, size: 16.sp, color: primaryColor),
              sizedBoxWidth(width: 12),
              CustomText(
                "${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: primaryColor),
              ),
              sizedBoxWidth(width: 8),
              Icon(Icons.arrow_drop_down_rounded, color: grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.grey;
    if (status?.toLowerCase() == 'present' || status?.toLowerCase() == 'punch_in') color = Colors.green;
    if (status?.toLowerCase() == 'leave') color = Colors.orange;
    if (status?.toLowerCase() == 'absent') color = Colors.red;

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
