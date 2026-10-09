import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';

class AssetReportScreen extends StatefulWidget {
  const AssetReportScreen({super.key});

  @override
  State<AssetReportScreen> createState() => _AssetReportScreenState();
}

class _AssetReportScreenState extends State<AssetReportScreen> {
  String? category;
  String? status;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getAssetReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      if (category != null) "category": category,
      if (status != null) "status": status,
      if (searchController.text.isNotEmpty) "search": searchController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Asset Report", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true, backgroundColor: white, elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.assetExport, search: _getSearchMap()),
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(children: [
            _buildFilters(),
            if (reportsController.isLoading && reportsController.assetReportList.isEmpty)
              Padding(padding: EdgeInsets.only(top: 100.h), child: const CircularProgressIndicator())
            else ...[
              if (reportsController.assetReportSummary != null)
                ReportSummaryWidget(items: [
                  ReportSummaryItemModel(label: "Total Assets", value: reportsController.assetReportSummary!.totalAssets.toString(), icon: Icons.inventory_2_rounded),
                  ReportSummaryItemModel(label: "Total Cost", value: PriceConverter.convertToNumberFormat(reportsController.assetReportSummary!.totalCost ?? 0), icon: Icons.payments_rounded),
                  ReportSummaryItemModel(label: "Available", value: reportsController.assetReportSummary!.available.toString(), icon: Icons.check_circle_rounded),
                  ReportSummaryItemModel(label: "Damaged", value: reportsController.assetReportSummary!.damaged.toString(), icon: Icons.report_problem_rounded),
                ]),
              if (reportsController.assetReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: Text("No data found"))
              else
                ListView.separated(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.r), itemCount: reportsController.assetReportList.length,
                  separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                  itemBuilder: (context, index) => _buildCard(reportsController.assetReportList[index]),
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
          decoration: InputDecoration(hintText: "Search...", prefixIcon: Icon(Icons.search), contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1))),
          onChanged: (v) => _fetchReport(),
        ),
        sizedBoxHeight(height: 12),
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(value: category, hint: Text("Category"), items: ['laptop', 'mobile', 'sim', 'id_card', 'other'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e.replaceAll("_", " "))))).toList(), onChanged: (v) { setState(() => category = v); _fetchReport(); })),
          sizedBoxWidth(width: 8),
          Expanded(child: DropdownButtonFormField<String>(value: status, hint: Text("Status"), items: ['available', 'issued', 'damaged', 'lost'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(), onChanged: (v) { setState(() => status = v); _fetchReport(); })),
        ]),
      ]),
    );
  }

  Widget _buildCard(item) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: CustomText(item.name ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
          _buildBadge(item.status),
        ]),
        sizedBoxHeight(height: 4),
        CustomText("${item.brand} • ${item.model}", style: TextStyle(fontSize: 12.sp, color: greyText)),
        sizedBoxHeight(height: 8),
        _infoRow(Icons.qr_code_rounded, "Code: ${item.assetCode ?? "N/A"}"),
        _infoRow(Icons.category_outlined, "Category: ${capitalize(item.category)}"),
        _infoRow(Icons.new_releases_outlined, "Condition: ${capitalize(item.condition)}"),
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomText("Purchase Cost:", style: TextStyle(fontSize: 11.sp, color: greyText)),
          CustomText(PriceConverter.convertToNumberFormat(item.purchaseCost ?? 0), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: primaryColor)),
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

  Widget _buildBadge(String? text) {
    Color color = text == 'available' ? Colors.green : Colors.blue;
    if (text == 'damaged' || text == 'lost') color = Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(text), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
