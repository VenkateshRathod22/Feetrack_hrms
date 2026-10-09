import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';

class DocumentReportScreen extends StatefulWidget {
  const DocumentReportScreen({super.key});

  @override
  State<DocumentReportScreen> createState() => _DocumentReportScreenState();
}

class _DocumentReportScreenState extends State<DocumentReportScreen> {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String? documentCategory;
  String? status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport() {
    Get.find<ReportsController>().getDocumentReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      "end_date": DateFormat('yyyy-MM-dd').format(endDate),
      if (documentCategory != null) "document_category": documentCategory,
      if (status != null) "status": status,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText("Documents & KYC", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.documentExport, search: _getSearchMap()),
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildFilters(),
              if (reportsController.isLoading && reportsController.documentReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: const Center(child: CircularProgressIndicator()))
              else ...[
                if (reportsController.documentReportSummary != null)
                  ReportSummaryWidget(items: [
                    ReportSummaryItemModel(
                        label: "Total Records",
                        value: reportsController.documentReportSummary!.totalRecords.toString(),
                        icon: Icons.folder_shared_rounded),
                    ReportSummaryItemModel(
                        label: "Pending Verification",
                        value: (reportsController.documentReportSummary!.statusCounts?['pending_verification'] ?? 0).toString(),
                        icon: Icons.pending_rounded),
                    ReportSummaryItemModel(
                        label: "Expiring Soon",
                        value: reportsController.documentReportSummary!.expiringSoon.toString(),
                        icon: Icons.notification_important_rounded),
                    ReportSummaryItemModel(
                        label: "KYC Docs",
                        value: (reportsController.documentReportSummary!.categoryCounts?['kyc'] ?? 0).toString(),
                        icon: Icons.assignment_ind_rounded),
                  ]),
                if (reportsController.documentReportList.isEmpty)
                  Padding(padding: EdgeInsets.only(top: 100.h), child: const Center(child: Text("No data found")))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.r),
                    itemCount: reportsController.documentReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) => _buildCard(reportsController.documentReportList[index]),
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
      child: Column(children: [
        Row(children: [
          Expanded(
              child: DropdownButtonFormField<String>(
                  value: documentCategory,
                  hint: Text("Category"),
                  items: ['kyc', 'education', 'experience', 'joining'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                  onChanged: (v) {
                    setState(() => documentCategory = v);
                    _fetchReport();
                  })),
          sizedBoxWidth(width: 8),
          Expanded(
              child: DropdownButtonFormField<String>(
                  value: status,
                  hint: Text("Status"),
                  items: ['verified', 'pending_verification', 'rejected']
                      .map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e.replaceAll("_", " ")))))
                      .toList(),
                  onChanged: (v) {
                    setState(() => status = v);
                    _fetchReport();
                  })),
        ]),
        sizedBoxHeight(height: 12),
        InkWell(
          onTap: () async {
            final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: DateTimeRange(start: startDate, end: endDate));
            if (picked != null) {
              setState(() {
                startDate = picked.start;
                endDate = picked.end;
              });
              _fetchReport();
            }
          },
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(border: Border.all(color: greyLight1), borderRadius: BorderRadius.circular(8.r)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
               Icon(Icons.calendar_today, size: 16, color: primaryColor),
              sizedBoxWidth(width: 8),
              Text("${DateFormat('dd-MM-yy').format(startDate)} - ${DateFormat('dd-MM-yy').format(endDate)}")
            ]),
          ),
        ),
      ]),
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
          sizedBoxHeight(height: 4),
          CustomText(item.title ?? "N/A", style: TextStyle(fontSize: 12.sp, color: primaryColor)),
          sizedBoxHeight(height: 8),
          _infoRow(Icons.pin_outlined, "Number: ${item.documentNumber ?? "N/A"}"),
          _infoRow(Icons.category_outlined, "Category: ${capitalize(item.documentCategory)}"),
          _infoRow(Icons.event_busy, "Expiry: ${item.expiryDate ?? "N/A"}"),
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
    Color color = text == 'verified' ? Colors.green : Colors.orange;
    if (text == 'rejected') color = Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(text?.replaceAll("_", " ")), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
