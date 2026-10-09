import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/probation_controller.dart';
import 'package:vlr/data/models/reports/probation_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/screens/probation/add_probotaion_screen.dart';
import 'package:vlr/views/screens/probation/probotion_detail_screen.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';
import 'package:collection/collection.dart';

class ProbationtScreen extends StatefulWidget {
  const ProbationtScreen({super.key});

  @override
  State<ProbationtScreen> createState() => _ProbationtScreenState();
}

class _ProbationtScreenState extends State<ProbationtScreen> {
  String? selectedBranch;
  String? selectedDepartment;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    Get.find<ProbationController>().getProbations();
    Get.find<BrachesController>().getBranchesList();
    Get.find<DepartmentController>().getDepartmentList();
  }

  Map<String, dynamic> _getFilterData() {
    Map<String, dynamic> filters = {};
    if (selectedBranch != null && selectedBranch != "All Branches") {
      final branch = Get.find<BrachesController>().branchList.firstWhereOrNull((e) => e.name == selectedBranch);
      if (branch != null) filters['branch_id'] = branch.id.toString();
    }
    if (selectedDepartment != null && selectedDepartment != "All Departments") {
      final dept = Get.find<DepartmentController>().departmentList.firstWhereOrNull((e) => e.name == selectedDepartment);
      if (dept != null) filters['department_id'] = dept.id.toString();
    }
    if (searchController.text.isNotEmpty) {
      filters['search'] = searchController.text;
    }
    return filters;
  }

  void _applyFilters() {
    Get.find<ProbationController>().getProbations(query: _getFilterData());
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
        title: CustomText("Probation Management", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigate(context: context, page: const AddProbotaionScreen()),
        backgroundColor: primaryColor,
        icon:  Icon(Icons.person_search_rounded, color: white),
        label: CustomText("Add Record", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ),
      body: GetBuilder<ProbationController>(builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            _applyFilters();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildFilterSection(),
                if (controller.isLoading && controller.probationList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (controller.probationList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No probation records found")),
                  )
                else
                  ListView.separated(
                    padding: EdgeInsets.all(16.r),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.probationList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = controller.probationList[index];
                      return _buildProbationCard(context, item);
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

  Widget _buildProbationCard(BuildContext context, ProbationModel item) {
    return GestureDetector(
      onTap: () => navigate(context: context, page: ProbotionDetailScreen(probationId: item.id!)),
      child: Container(
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
                      CustomText(item.employeeCode ?? "EMP-XXXX", style: TextStyle(fontSize: 11.sp, color: greyText)),
                    ],
                  ),
                ),
                _buildStatusBadge(item.status),
                _buildActionMenu(context, item),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem("Start Date", _formatDate(item.startDate)),
                _infoItem("Due Date", _formatDate(item.confirmationDueDate)),
                if (item.isExtended == true)
                  _infoItem("Extended", _formatDate(item.extendedDueDate)),
              ],
            ),
            if (item.assetAllocation != null && item.assetAllocation!.isNotEmpty) ...[
              sizedBoxHeight(height: 12),
              const Divider(),
              sizedBoxHeight(height: 8),
              Row(
                children: [
                  Icon(Icons.inventory_2_outlined, size: 14.sp, color: greyText),
                  sizedBoxWidth(width: 8),
                  Expanded(
                    child: CustomText(item.assetAllocation!, style: TextStyle(fontSize: 11.sp, color: greyDart2), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return dateStr.split("T")[0];
    }
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 9.sp, color: greyText)),
        CustomText(value, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: blackText1)),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.blue;
    if (status == 'confirmed') color = Colors.green;
    if (status == 'extended') color = Colors.orange;
    if (status == 'terminated') color = Colors.red;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(status?.replaceAll("_", " ")), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionMenu(BuildContext context, ProbationModel item) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert_rounded, size: 20, color: greyDart2),
      onSelected: (val) {
        if (val == 'edit') {
          navigate(context: context, page: AddProbotaionScreen(probationModel: item));
        } else if (val == 'delete') {
          _confirmDelete(context, item);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Edit")])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_rounded, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete")])),
      ],
    );
  }

  void _confirmDelete(BuildContext context, ProbationModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Record?"),
        content: Text("Are you sure you want to delete the probation record for ${item.employeeName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<ProbationController>().deleteProbationRecord(item.id!).then((res) {
                if (res.isSuccess) {
                  showToast(message: res.message, toastType: ToastType.success);
                } else {
                  showToast(message: res.message, toastType: ToastType.error);
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
