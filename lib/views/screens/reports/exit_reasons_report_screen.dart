import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';

class ExitReasonsReportScreen extends StatefulWidget {
  const ExitReasonsReportScreen({super.key});

  @override
  State<ExitReasonsReportScreen> createState() => _ExitReasonsReportScreenState();
}

class _ExitReasonsReportScreenState extends State<ExitReasonsReportScreen> {
  String? exitType;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getExitReasonsReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      if (exitType != null) "exit_type": exitType,
      if (searchController.text.isNotEmpty) "search": searchController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Exit Reasons Report",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(
              uri: AppConstants.exitReasonsExport,
              search: _getSearchMap(),
            ),
            icon: const Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildFilters(),
              if (reportsController.isLoading && reportsController.exitReasonReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.exitReasonReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Reasons",
                        value: reportsController.exitReasonReportSummary!.totalReasons.toString(),
                        icon: Icons.list_alt_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Voluntary",
                        value: reportsController.exitReasonReportSummary!.voluntaryCount.toString(),
                        icon: Icons.person_remove_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Involuntary",
                        value: reportsController.exitReasonReportSummary!.involuntaryCount.toString(),
                        icon: Icons.person_off_rounded,
                      ),
                    ],
                  ),
                if (reportsController.exitReasonReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.exitReasonReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final reason = reportsController.exitReasonReportList[index];
                      return _buildReasonCard(context, reason);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReasonCard(BuildContext context, reason) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                reason.name ?? "N/A",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
              ),
            ),
            _buildTypeBadge(reason.type),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search reasons...",
              prefixIcon: const Icon(Icons.search_rounded),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: greyLight1),
              ),
            ),
            onChanged: (v) => _fetchReport(),
          ),
          sizedBoxHeight(height: 12),
          DropdownButtonFormField<String>(
            value: exitType,
            hint: const Text("Exit Type"),
            items: ['voluntary', 'involuntary']
                .map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e))))
                .toList(),
            onChanged: (v) {
              setState(() => exitType = v);
              _fetchReport();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String? type) {
    Color color = type == 'voluntary' ? Colors.blue : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(type),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
