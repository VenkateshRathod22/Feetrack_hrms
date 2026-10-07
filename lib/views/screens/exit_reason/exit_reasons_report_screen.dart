import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/controllers/exit_reason_controller.dart';
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
    Get.find<ExitReasonController>().getExitReasonsReport(search: _getSearchMap());
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
        title: CustomText("Exit Reasons", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true, backgroundColor: white, elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.exitReasonsExport, search: _getSearchMap()),
            icon: const Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ExitReasonController>(builder: (exitReasonController) {
        return SingleChildScrollView(
          child: Column(children: [
            _buildFilters(),
            if (exitReasonController.isLoading && exitReasonController.exitReasonReportList.isEmpty)
              Padding(padding: EdgeInsets.only(top: 100.h), child: const CircularProgressIndicator())
            else ...[
              if (exitReasonController.exitReasonReportSummary != null)
                ReportSummaryWidget(items: [
                  ReportSummaryItemModel(label: "Total Reasons", value: exitReasonController.exitReasonReportSummary!.totalReasons.toString(), icon: Icons.list_alt_rounded),
                  ReportSummaryItemModel(label: "Voluntary", value: exitReasonController.exitReasonReportSummary!.voluntaryCount.toString(), icon: Icons.person_remove_rounded),
                  ReportSummaryItemModel(label: "Involuntary", value: exitReasonController.exitReasonReportSummary!.involuntaryCount.toString(), icon: Icons.person_off_rounded),
                ]),
              if (exitReasonController.exitReasonReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: const Text("No data found"))
              else
                ListView.separated(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.r), itemCount: exitReasonController.exitReasonReportList.length,
                  separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                  itemBuilder: (context, index) => _buildCard(exitReasonController.exitReasonReportList[index]),
                ),
            ],
          ]),
        );
      }),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16.r), margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(hintText: "Search...", prefixIcon: const Icon(Icons.search), contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1))),
          onChanged: (v) => _fetchReport(),
        ),
        sizedBoxHeight(height: 12),
        DropdownButtonFormField<String>(value: exitType, hint: const Text("Exit Type"), items: ['voluntary', 'involuntary'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(), onChanged: (v) { setState(() => exitType = v); _fetchReport(); }),
      ]),
    );
  }

  Widget _buildCard(item) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: CustomText(item.name ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
        _buildBadge(item.type),
      ]),
    );
  }

  Widget _buildBadge(String? text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(text), style: TextStyle(fontSize: 10.sp, color: Colors.blue, fontWeight: FontWeight.bold)),
    );
  }
}
