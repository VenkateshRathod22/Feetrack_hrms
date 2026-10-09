import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';

class TrainingReportScreen extends StatefulWidget {
  const TrainingReportScreen({super.key});

  @override
  State<TrainingReportScreen> createState() => _TrainingReportScreenState();
}

class _TrainingReportScreenState extends State<TrainingReportScreen> {
  String? departmentId;
  String? status;
  String? result;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DepartmentController>().getDepartmentList();
      _fetchReport();
    });
  }

  void _fetchReport() {
    Get.find<ReportsController>().getTrainingReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      if (departmentId != null) "department_id": departmentId,
      if (status != null) "status": status,
      if (result != null) "result": result,
      if (searchController.text.isNotEmpty) "training_title": searchController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText("Training Report", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.trainingExport, search: _getSearchMap()),
            icon: Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(children: [
            _buildFilters(),
            if (reportsController.isLoading && reportsController.trainingReportList.isEmpty)
              Padding(padding: EdgeInsets.only(top: 100.h), child: const Center(child: CircularProgressIndicator()))
            else ...[
              if (reportsController.trainingReportSummary != null)
                ReportSummaryWidget(items: [
                  ReportSummaryItemModel(label: "Assigned", value: reportsController.trainingReportSummary!.totalAssigned.toString(), icon: Icons.assignment_ind_rounded),
                  ReportSummaryItemModel(label: "Completed", value: reportsController.trainingReportSummary!.totalCompleted.toString(), icon: Icons.check_circle_rounded),
                  ReportSummaryItemModel(label: "Pending", value: reportsController.trainingReportSummary!.totalPending.toString(), icon: Icons.pending_actions_rounded),
                ]),
              if (reportsController.trainingReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: const Center(child: Text("No data found")))
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.r),
                  itemCount: reportsController.trainingReportList.length,
                  separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                  itemBuilder: (context, index) => _buildCard(reportsController.trainingReportList[index]),
                ),
            ],
          ]),
        );
      }),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: "Training Title...",
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1))),
          onChanged: (v) => _fetchReport(),
        ),
        sizedBoxHeight(height: 12),
        Row(children: [
          Expanded(
              child: DropdownButtonFormField<String>(
                  value: status,
                  hint: Text("Status"),
                  items: ['assigned', 'in_progress', 'completed']
                      .map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e.replaceAll("_", " ")))))
                      .toList(),
                  onChanged: (v) {
                    setState(() => status = v);
                    _fetchReport();
                  })),
          sizedBoxWidth(width: 8),
          Expanded(
              child: DropdownButtonFormField<String>(
                  value: result,
                  hint: Text("Result"),
                  items: ['pending', 'passed', 'failed'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                  onChanged: (v) {
                    setState(() => result = v);
                    _fetchReport();
                  })),
        ]),
        sizedBoxHeight(height: 12),
        GetBuilder<DepartmentController>(builder: (dept) {
          return DropdownButtonFormField<String>(
              isExpanded: true,
              value: departmentId,
              hint: Text("All Departments"),
              items: [
                const DropdownMenuItem(value: null, child: Text("All Departments")),
                ...dept.departmentList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? "")))
              ],
              onChanged: (v) {
                setState(() => departmentId = v);
                _fetchReport();
              });
        }),
      ]),
    );
  }

  Widget _buildCard(item) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: CustomText(item.trainingTitle ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
          _buildBadge(item.status),
        ]),
        sizedBoxHeight(height: 4),
        CustomText("Employee: ${item.employeeName ?? "N/A"}", style: TextStyle(fontSize: 12.sp, color: primaryColor)),
        sizedBoxHeight(height: 8),
        _infoRow(Icons.person_outline, "Trainer: ${item.trainer ?? "N/A"}"),
        _infoRow(Icons.poll_outlined, "Result: ${capitalize(item.result)}"),
        sizedBoxHeight(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _scoreItem("Attendance", "${item.attendancePercentage}%"),
          _scoreItem("Score", "${item.assessmentScore}%"),
        ]),
      ]),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(children: [Icon(icon, size: 14, color: grey), sizedBoxWidth(width: 8), Text(text, style: TextStyle(fontSize: 11.sp, color: greyDart2))]),
    );
  }

  Widget _scoreItem(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
      CustomText(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackText1)),
    ]);
  }

  Widget _buildBadge(String? text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(text?.replaceAll("_", " ")), style: TextStyle(fontSize: 10.sp, color: Colors.blue, fontWeight: FontWeight.bold)),
    );
  }
}
