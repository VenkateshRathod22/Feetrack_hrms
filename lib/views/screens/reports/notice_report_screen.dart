import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/reports/widget/report_staff_filter_widget.dart';

class NoticeReportScreen extends StatefulWidget {
  const NoticeReportScreen({super.key});

  @override
  State<NoticeReportScreen> createState() => _NoticeReportScreenState();
}

class _NoticeReportScreenState extends State<NoticeReportScreen> {
  String search = "";
  String? departmentId;
  String? roleId;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getNoticeReport(search: _getSearchMap());
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
          "Notice Report",
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
                uri: AppConstants.noticeExport,
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
              if (reportsController.isLoading && reportsController.noticeReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.noticeReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Notices",
                        value: reportsController.noticeReportSummary!.totalNotices.toString(),
                        icon: Icons.campaign_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Global Notices",
                        value: (reportsController.noticeReportSummary!.typeCounts?['global'] ?? 0).toString(),
                        icon: Icons.public_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Dept Notices",
                        value: (reportsController.noticeReportSummary!.typeCounts?['department'] ?? 0).toString(),
                        icon: Icons.business_rounded,
                      ),
                    ],
                  ),
                if (reportsController.noticeReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.noticeReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final notice = reportsController.noticeReportList[index];
                      return _buildNoticeCard(context, notice);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNoticeCard(BuildContext context, notice) {
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
                    notice.title ?? "N/A",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                  ),
                ),
                _buildTypeBadge(notice.type),
              ],
            ),
            sizedBoxHeight(height: 8),
            CustomText(
              notice.content ?? "N/A",
              style: TextStyle(fontSize: 12.sp, color: greyDart2),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dateInfo("Start", notice.startDate),
                _dateInfo("End", notice.endDate),
              ],
            ),
            const Divider(),
            sizedBoxHeight(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 12.sp, color: grey),
                sizedBoxWidth(width: 4),
                CustomText(
                  "Created: ${notice.createdAt?.split(" ")[0] ?? "N/A"}",
                  style: TextStyle(fontSize: 11.sp, color: greyText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateInfo(String label, String? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
        CustomText(date?.split(" ")[0] ?? "N/A", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: blackText1)),
      ],
    );
  }

  Widget _buildTypeBadge(String? type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(type),
        style: TextStyle(fontSize: 10.sp, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
}
