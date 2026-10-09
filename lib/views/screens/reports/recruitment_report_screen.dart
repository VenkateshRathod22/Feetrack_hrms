import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';

class RecruitmentReportScreen extends StatefulWidget {
  const RecruitmentReportScreen({super.key});

  @override
  State<RecruitmentReportScreen> createState() => _RecruitmentReportScreenState();
}

class _RecruitmentReportScreenState extends State<RecruitmentReportScreen> {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String? departmentId;
  String? interviewStage;

  @override
  void initState() {
    super.initState();
    Get.find<DepartmentController>().getDepartmentList();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getRecruitmentReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      "end_date": DateFormat('yyyy-MM-dd').format(endDate),
      if (departmentId != null) "department_id": departmentId,
      if (interviewStage != null) "interview_stage": interviewStage,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Recruitment Report", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.recruitmentExport, search: _getSearchMap()),
            icon: Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildFilters(),
              if (reportsController.isLoading && reportsController.recruitmentReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: const CircularProgressIndicator())
              else ...[
                if (reportsController.recruitmentReportSummary != null)
                  ReportSummaryWidget(items: [
                    ReportSummaryItemModel(
                        label: "Candidates",
                        value: reportsController.recruitmentReportSummary!.totalCandidates.toString(),
                        icon: Icons.people_rounded),
                    ReportSummaryItemModel(
                        label: "Vacancies",
                        value: reportsController.recruitmentReportSummary!.totalVacancies.toString(),
                        icon: Icons.work_rounded),
                    ReportSummaryItemModel(
                        label: "Under Review",
                        value: (reportsController.recruitmentReportSummary!.statusCounts?['under_review'] ?? 0).toString(),
                        icon: Icons.rate_review_rounded),
                    ReportSummaryItemModel(
                        label: "Pending Offers",
                        value: (reportsController.recruitmentReportSummary!.offerCounts?['pending'] ?? 0).toString(),
                        icon: Icons.local_offer_rounded),
                  ]),
                if (reportsController.recruitmentReportList.isEmpty)
                  Padding(padding: EdgeInsets.only(top: 100.h), child: Text("No data found"))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.r),
                    itemCount: reportsController.recruitmentReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) => _buildCard(reportsController.recruitmentReportList[index]),
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GetBuilder<DepartmentController>(builder: (dept) {
                  return DropdownButtonFormField<String>(
                    value: departmentId,
                    hint: Text("Dept"),
                    items: [const DropdownMenuItem(value: null, child: Text("All Depts")), ...dept.departmentList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? "")))],
                    onChanged: (v) { setState(() => departmentId = v); _fetchReport(); },
                  );
                }),
              ),
              sizedBoxWidth(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: interviewStage,
                  hint: Text("Stage"),
                  items: ['applied', 'interviewed', 'offered', 'joined', 'rejected'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                  onChanged: (v) { setState(() => interviewStage = v); _fetchReport(); },
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          InkWell(
            onTap: () async {
              final picked = await showDateRangePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)), initialDateRange: DateTimeRange(start: startDate, end: endDate));
              if (picked != null) { setState(() { startDate = picked.start; endDate = picked.end; }); _fetchReport(); }
            },
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(border: Border.all(color: greyLight1), borderRadius: BorderRadius.circular(8.r)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.calendar_today, size: 16, color: primaryColor), sizedBoxWidth(width: 8), Text("${DateFormat('dd-MM-yy').format(startDate)} - ${DateFormat('dd-MM-yy').format(endDate)}")]),
            ),
          ),
        ],
      ),
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
              Expanded(child: CustomText(item.candidateName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
              _buildBadge(item.interviewStage),
            ],
          ),
          sizedBoxHeight(height: 4),
          CustomText(item.jobTitle ?? "N/A", style: TextStyle(fontSize: 12.sp, color: primaryColor)),
          sizedBoxHeight(height: 8),
          _infoRow(Icons.email_outlined, item.candidateEmail ?? "N/A"),
          _infoRow(Icons.phone_outlined, item.candidatePhone ?? "N/A"),
          _infoRow(Icons.business_outlined, item.department ?? "N/A"),
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
      decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(text), style: TextStyle(fontSize: 10.sp, color: primaryColor, fontWeight: FontWeight.bold)),
    );
  }
}
