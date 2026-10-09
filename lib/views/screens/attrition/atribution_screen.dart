import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/attrition_controller.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/data/models/reports/attrition_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/screens/attrition/exit_reason_screen.dart';
import 'package:vlr/views/screens/attrition/record_exit_screen.dart';
import 'package:vlr/views/screens/attrition/widget/atribution_summary_widget.dart';
import 'package:vlr/views/screens/attrition/widget/attribuiton_graph_card_widget.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AttritionScreen extends StatefulWidget {
  const AttritionScreen({super.key});

  @override
  State<AttritionScreen> createState() => _AttritionScreenState();
}

class _AttritionScreenState extends State<AttritionScreen> {
  String? selectedYear = DateTime.now().year.toString();
  String? selectedMonth;
  String? selectedBranch;
  String? selectedDepartment;
  String? selectedExitType;
  String? selectedExitReason;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    Get.find<AttritionController>().getAttritionReport();
    Get.find<AttritionController>().getExitReasons();
    Get.find<BrachesController>().getBranchesList();
    Get.find<DepartmentController>().getDepartmentList();
  }

  Map<String, dynamic> _getFilterData() {
    Map<String, dynamic> filters = {};
    if (selectedYear != null) filters['year'] = selectedYear;
    if (selectedMonth != null) {
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
    if (selectedExitType != null && selectedExitType != "All Types") {
      filters['exit_type'] = selectedExitType!.toLowerCase();
    }
    if (selectedExitReason != null && selectedExitReason != "All Reasons") {
      filters['exit_reason'] = selectedExitReason;
    }
    if (searchController.text.isNotEmpty) {
      filters['search'] = searchController.text;
    }
    return filters;
  }

  void _applyFilters() {
    Get.find<AttritionController>().getAttritionReport(search: _getFilterData());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Attrition Management",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => navigate(context: context, page: const ExitReasonScreen()),
            icon:  Icon(Icons.list_alt_rounded, color: primaryColor),
            tooltip: "Exit Reasons",
          ),
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(
              uri: AppConstants.attritionExport,
              search: _getFilterData(),
            ),
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigate(context: context, page: const RecordExitScreen());
        },
        backgroundColor: primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        icon: Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: CustomText(
          "Record Exit",
          style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
      ),
      body: GetBuilder<AttritionController>(builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            _applyFilters();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildFilterSection(),
                const AtributionSummaryWidget(),
                const AtribuitonGraphCardWidget(),
                sizedBoxHeight(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      CustomText("Exit Records",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
                    ],
                  ),
                ),
                sizedBoxHeight(height: 12),
                if (controller.isLoading && controller.attritionReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (controller.attritionReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: controller.attritionReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final record = controller.attritionReportList[index];
                      return _buildRecordCard(record);
                    },
                  ),
              ],
            ),
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
                    _applyFilters();
                  },
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Month",
                  items: ["All Months", ...months],
                  value: selectedMonth ?? "All Months",
                  onChanged: (val) {
                    setState(() => selectedMonth = val == "All Months" ? null : val);
                    _applyFilters();
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
                _applyFilters();
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
                _applyFilters();
              },
            );
          }),
          sizedBoxHeight(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Exit Type",
                  items: const ["All Types", "Voluntary", "Involuntary"],
                  value: selectedExitType ?? "All Types",
                  onChanged: (val) {
                    setState(() => selectedExitType = val == "All Types" ? null : val);
                    _applyFilters();
                  },
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: GetBuilder<AttritionController>(builder: (controller) {
                  return CustomDropDownList<String>(
                    heading: "Exit Reason",
                    items: ["All Reasons", ...controller.exitReasonList.map((e) => e.name ?? "")],
                    value: selectedExitReason ?? "All Reasons",
                    onChanged: (val) {
                      setState(() => selectedExitReason = val == "All Reasons" ? null : val);
                      _applyFilters();
                    },
                  );
                }),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          AppTextFieldWithHeading(
            controller: searchController,
            heading: "Search Employee",
            hindText: "Enter employee name",
            onChanged: (val) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                _applyFilters();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(AttritionReportModel record) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(record.employeeName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
                    CustomText("${record.department} • ${record.branch}", style: TextStyle(fontSize: 11.sp, color: greyText)),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildBadge(record.exitType),
                  sizedBoxWidth(width: 8),
                  _buildActionMenu(record),
                ],
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          _infoRow(
              Icons.calendar_today,
              "Exit Date: ${record.exitDate != null ? _formatDate(record.exitDate!) : "N/A"}"),
          _infoRow(Icons.help_outline, "Reason: ${record.exitReason ?? "N/A"}"),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return dateStr.split("T")[0];
    }
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 14, color: grey),
          sizedBoxWidth(width: 8),
          Text(text, style: TextStyle(fontSize: 11.sp, color: greyDart2)),
        ],
      ),
    );
  }

  Widget _buildBadge(String? text) {
    Color color = text?.toLowerCase() == 'voluntary' ? Colors.orange : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(capitalize(text), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionMenu(AttritionReportModel record) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert_rounded, size: 20, color: greyDart2),
      onSelected: (val) {
        if (val == 'edit') {
          navigate(context: context, page: RecordExitScreen(attritionModel: record));
        } else if (val == 'delete') {
          _confirmDelete(context, record);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
            value: 'edit',
            child: Row(children: [Icon(Icons.edit_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Edit")])),
        const PopupMenuItem(
            value: 'delete',
            child: Row(children: [Icon(Icons.delete_rounded, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete")])),
      ],
    );
  }

  void _confirmDelete(BuildContext context, AttritionReportModel record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Record?"),
        content: Text("Are you sure you want to delete the exit record for ${record.employeeName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<AttritionController>().deleteAttritionRecord(record.id!).then((response) {
                if (response.isSuccess) {
                  showToast(message: response.message, toastType: ToastType.success);
                } else {
                  showToast(message: response.message, toastType: ToastType.error);
                }
              });
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
