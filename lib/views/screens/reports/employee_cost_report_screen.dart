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

class EmployeeCostReportScreen extends StatefulWidget {
  const EmployeeCostReportScreen({super.key});

  @override
  State<EmployeeCostReportScreen> createState() => _EmployeeCostReportScreenState();
}

class _EmployeeCostReportScreenState extends State<EmployeeCostReportScreen> {
  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = DateTime.now().month.toString();
  String? departmentId;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<DepartmentController>().getDepartmentList();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<ReportsController>().getEmployeeCostReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      "year": selectedYear,
      "month": selectedMonth,
      if (departmentId != null) "department_id": departmentId,
      if (searchController.text.isNotEmpty) "search": searchController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Employee Cost", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true, backgroundColor: white, elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(uri: AppConstants.employeeCostExport, search: _getSearchMap()),
            icon: const Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(children: [
            _buildFilters(),
            if (reportsController.isLoading && reportsController.employeeCostReportList.isEmpty)
              Padding(padding: EdgeInsets.only(top: 100.h), child: const CircularProgressIndicator())
            else ...[
                if (reportsController.employeeCostReportSummary != null)
                  ReportSummaryWidget(items: [
                    ReportSummaryItemModel(
                        label: "Total Cost",
                        value: PriceConverter.convertToNumberFormat(reportsController.employeeCostReportSummary!.totalEmployeeCost ?? 0),
                        icon: Icons.account_balance_wallet_rounded),
                    ReportSummaryItemModel(
                        label: "Salary Cost",
                        value: PriceConverter.convertToNumberFormat(reportsController.employeeCostReportSummary!.totalSalaryCost ?? 0),
                        icon: Icons.payments_rounded),
                    ReportSummaryItemModel(
                        label: "Overtime Cost",
                        value: PriceConverter.convertToNumberFormat(reportsController.employeeCostReportSummary!.totalOvertimeCost ?? 0),
                        icon: Icons.more_time_rounded),
                    ReportSummaryItemModel(
                        label: "Incentive Cost",
                        value: PriceConverter.convertToNumberFormat(reportsController.employeeCostReportSummary!.totalIncentiveCost ?? 0),
                        icon: Icons.card_giftcard_rounded),
                    ReportSummaryItemModel(
                        label: "Employees",
                        value: reportsController.employeeCostReportSummary!.totalEmployees.toString(),
                        icon: Icons.group_rounded),
                  ]),
              if (reportsController.employeeCostReportList.isEmpty)
                Padding(padding: EdgeInsets.only(top: 100.h), child: const Text("No data found"))
              else
                ListView.separated(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.r), itemCount: reportsController.employeeCostReportList.length,
                  separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                  itemBuilder: (context, index) => _buildCard(reportsController.employeeCostReportList[index]),
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
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(value: selectedYear, hint: const Text("Year"), items: List.generate(5, (i) => (DateTime.now().year - i).toString()).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) { setState(() => selectedYear = v!); _fetchReport(); })),
          sizedBoxWidth(width: 8),
          Expanded(child: DropdownButtonFormField<String>(value: selectedMonth, hint: const Text("Month"), items: List.generate(12, (i) => (i + 1).toString()).map((e) => DropdownMenuItem(value: e, child: Text(DateFormat('MMMM').format(DateTime(2022, int.parse(e)))))).toList(), onChanged: (v) { setState(() => selectedMonth = v!); _fetchReport(); })),
        ]),
        sizedBoxHeight(height: 12),
        GetBuilder<DepartmentController>(builder: (dept) { return DropdownButtonFormField<String>(isExpanded: true, value: departmentId, hint: const Text("All Departments"), items: [const DropdownMenuItem(value: null, child: Text("All Departments")), ...dept.departmentList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? "")))], onChanged: (v) { setState(() => departmentId = v); _fetchReport(); }); }),
      ]),
    );
  }

  Widget _buildCard(item) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomText(item.employeeName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
        sizedBoxHeight(height: 4),
        CustomText("${item.department} • ${item.branch}", style: TextStyle(fontSize: 11.sp, color: greyText)),
        sizedBoxHeight(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _costItem("Salary", item.salaryCost),
          _costItem("OT", item.otCost),
          _costItem("Incentive", item.incentiveCost),
        ]),
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const CustomText("Total Cost:", style: TextStyle(fontWeight: FontWeight.bold)),
          CustomText(PriceConverter.convertToNumberFormat(item.totalCost ?? 0), style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
        ]),
      ]),
    );
  }

  Widget _costItem(String label, num? amount) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
      CustomText(PriceConverter.convertToNumberFormat(amount ?? 0), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
    ]);
  }
}
