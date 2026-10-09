import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/employee_cost_controller.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/reports/employee_cost_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/employee_cost/widget/pie_grapgh_employee_cost_widget.dart';
import 'package:vlr/views/screens/employee_cost/widget/bar_grapgh_employee_cost_widget.dart';
import 'package:vlr/views/screens/employee_cost/widget/branch_cost_breakdown_widget.dart';
import 'package:collection/collection.dart';

class EmployeeCostReportScreen extends StatefulWidget {
  const EmployeeCostReportScreen({super.key});

  @override
  State<EmployeeCostReportScreen> createState() => _EmployeeCostReportScreenState();
}

class _EmployeeCostReportScreenState extends State<EmployeeCostReportScreen> {
  String? selectedYear = DateTime.now().year.toString();
  String? selectedMonth;
  String? selectedBranch;
  String? selectedDepartment;
  String? selectedEmployee;
  final TextEditingController searchController = TextEditingController();

  final List<String> years = [
    for (int i = DateTime.now().year - 2; i <= DateTime.now().year + 2; i++) i.toString()
  ];
  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _fetchReport();
    Get.find<BrachesController>().getBranchesList();
    Get.find<DepartmentController>().getDepartmentList();
    Get.find<StaffController>().getEmployeesListing();
  }

  Map<String, dynamic> _getFilterData() {
    Map<String, dynamic> filters = {};
    if (selectedYear != null) filters['year'] = selectedYear;
    if (selectedMonth != null && selectedMonth != "Full Year (Jan-Dec)") {
      int monthIdx = months.indexOf(selectedMonth!) + 1;
      filters['month'] = monthIdx.toString().padLeft(2, '0');
    }
    if (selectedBranch != null && selectedBranch != "All Branches") {
      final branches = Get.find<BrachesController>().branchList;
      final branch = branches.firstWhereOrNull((e) => e.name == selectedBranch);
      if (branch != null) filters['branch_id'] = branch.id.toString();
    }
    if (selectedDepartment != null && selectedDepartment != "All Departments") {
      final depts = Get.find<DepartmentController>().departmentList;
      final dept = depts.firstWhereOrNull((e) => e.name == selectedDepartment);
      if (dept != null) filters['department_id'] = dept.id.toString();
    }
    if (selectedEmployee != null && selectedEmployee != "All Employees") {
      final employees = Get.find<StaffController>().employeeListing;
      final emp = employees.firstWhereOrNull((e) => e.name == selectedEmployee);
      if (emp != null) filters['employee_id'] = emp.id.toString();
    }
    if (searchController.text.isNotEmpty) {
      filters['search'] = searchController.text;
    }
    return filters;
  }

  void _fetchReport() {
    Get.find<EmployeeCostController>().getEmployeeCostReport(search: _getFilterData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText("Employee Cost Report", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(
              uri: AppConstants.employeeCostExport,
              search: _getFilterData(),
            ),
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<EmployeeCostController>(builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildFilterSection(),
              if (controller.isLoading && controller.employeeCostList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (controller.analytics?.summary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Cost",
                        value: PriceConverter.convertToNumberFormat(controller.analytics!.summary!.totalEmployeeCost ?? 0),
                        icon: Icons.payments_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Salary Cost",
                        value: PriceConverter.convertToNumberFormat(controller.analytics!.summary!.totalSalaryCost ?? 0),
                        icon: Icons.money_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "CTC Cost",
                        value: PriceConverter.convertToNumberFormat(controller.analytics!.summary!.totalCtcCost ?? 0),
                        icon: Icons.account_balance_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Incentives",
                        value: PriceConverter.convertToNumberFormat(controller.analytics!.summary!.totalIncentiveCost ?? 0),
                        icon: Icons.card_giftcard_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Overtime",
                        value: PriceConverter.convertToNumberFormat(controller.analytics!.summary!.totalOvertimeCost ?? 0),
                        icon: Icons.more_time_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "OT Hours",
                        value: "${controller.analytics!.summary!.totalOvertimeHours ?? 0}h",
                        icon: Icons.timer_outlined,
                      ),
                      ReportSummaryItemModel(
                        label: "Employees",
                        value: controller.analytics!.summary!.totalEmployees.toString(),
                        icon: Icons.people_rounded,
                      ),
                    ],
                  ),
                const BarGrapghEmployeeCostWidget(),
                const PieGrapghEmployeeCostWidget(),
                const BranchCostBreakdownWidget(),
                sizedBoxHeight(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      CustomText("Employee Breakdown", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
                    ],
                  ),
                ),
                sizedBoxHeight(height: 12),
                if (controller.employeeCostList.isEmpty)
                  const Center(child: Text("No data found"))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: controller.employeeCostList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = controller.employeeCostList[index];
                      return _buildEmployeeCostCard(item);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Year",
                  items: years,
                  value: selectedYear,
                  onChanged: (val) {
                    setState(() => selectedYear = val);
                    _fetchReport();
                  },
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Month",
                  items: ["Full Year (Jan-Dec)", ...months],
                  value: selectedMonth ?? "Full Year (Jan-Dec)",
                  onChanged: (val) {
                    setState(() => selectedMonth = val == "Full Year (Jan-Dec)" ? null : val);
                    _fetchReport();
                  },
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          GetBuilder<BrachesController>(builder: (branchController) {
            return CustomDropDownList<String>(
              heading: "Branch",
              items: ["All Branches", ...branchController.branchList.map((e) => e.name ?? "")],
              value: selectedBranch ?? "All Branches",
              onChanged: (val) {
                setState(() => selectedBranch = val == "All Branches" ? null : val);
                _fetchReport();
              },
            );
          }),
          sizedBoxHeight(height: 12),
          GetBuilder<DepartmentController>(builder: (deptController) {
            return CustomDropDownList<String>(
              heading: "Department",
              items: ["All Departments", ...deptController.departmentList.map((e) => e.name ?? "")],
              value: selectedDepartment ?? "All Departments",
              onChanged: (val) {
                setState(() => selectedDepartment = val == "All Departments" ? null : val);
                _fetchReport();
              },
            );
          }),
          sizedBoxHeight(height: 12),
          GetBuilder<StaffController>(builder: (staffController) {
            return CustomDropDownList<String>(
              heading: "Employee",
              items: ["All Employees", ...staffController.employeeListing.map((e) => e.name ?? "")],
              value: selectedEmployee ?? "All Employees",
              onChanged: (val) {
                setState(() => selectedEmployee = val == "All Employees" ? null : val);
                _fetchReport();
              },
            );
          }),
          sizedBoxHeight(height: 12),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search employee...",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: backgroundLight,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
            ),
            onChanged: (v) => _fetchReport(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCostCard(EmployeeCostReportModel item) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(item.employeeName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
                    CustomText("${item.designation} • ${item.department}", style: TextStyle(fontSize: 11.sp, color: greyText)),
                    CustomText(item.branch ?? "N/A", style: TextStyle(fontSize: 11.sp, color: greyText)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    PriceConverter.convertToNumberFormat(item.totalCost ?? 0),
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  CustomText(
                    "Total Cost",
                    style: TextStyle(fontSize: 9.sp, color: greyText),
                  ),
                ],
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          Row(
            children: [
              Icon(Icons.email_outlined, size: 12.sp, color: greyText),
              sizedBoxWidth(width: 4),
              CustomText(item.email ?? "N/A", style: TextStyle(fontSize: 10.sp, color: blackText1)),
              sizedBoxWidth(width: 12),
              Icon(Icons.phone_outlined, size: 12.sp, color: greyText),
              sizedBoxWidth(width: 4),
              CustomText(item.mobile ?? "N/A", style: TextStyle(fontSize: 10.sp, color: blackText1)),
            ],
          ),
          sizedBoxHeight(height: 12),
          const Divider(),
          sizedBoxHeight(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _detailItem("Monthly Salary", item.monthlySalary),
              _detailItem("OT (${item.otHours ?? 0}h)", item.otCost),
              _detailItem("Incentives", item.incentiveCost),
              _detailItem("Annual CTC", item.annualCtc),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, num? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
        CustomText(PriceConverter.convertToNumberFormat(value ?? 0), style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
