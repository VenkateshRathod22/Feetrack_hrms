import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/pip_controller.dart';
import 'package:vlr/data/models/reports/pip_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/screens/pip/add_pip_screen.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';
import 'package:collection/collection.dart';

class PipScreen extends StatefulWidget {
  const PipScreen({super.key});

  @override
  State<PipScreen> createState() => _PipScreenState();
}

class _PipScreenState extends State<PipScreen> {
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
    Get.find<PipController>().getPips();
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
    Get.find<PipController>().getPips(query: _getFilterData());
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
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Performance Plans (PIP)", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigate(context: context, page: const AddPipScreen()),
        backgroundColor: primaryColor,
        icon:  Icon(Icons.add_task_rounded, color: white),
        label: CustomText("Create PIP", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ),
      body: GetBuilder<PipController>(builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            _applyFilters();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildFilterSection(),
                if (controller.isLoading && controller.pipList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (controller.pipList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No PIP records found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.r),
                    itemCount: controller.pipList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final pip = controller.pipList[index];
                      return _buildPipCard(context, pip);
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

  Widget _buildPipCard(BuildContext context, PipModel pip) {
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
                    CustomText(pip.employeeName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
                    CustomText(pip.reason ?? "No reason specified", style: TextStyle(fontSize: 11.sp, color: greyDart2), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              _buildStatusBadge(pip.status),
              _buildActionMenu(context, pip),
            ],
          ),
          sizedBoxHeight(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem("Start Date", _formatDate(pip.startDate)),
              _infoItem("End Date", _formatDate(pip.endDate)),
              _infoItem("Result", pip.reviewResult ?? "Pending"),
            ],
          ),
          sizedBoxHeight(height: 12),
          const Divider(),
          sizedBoxHeight(height: 8),
          CustomText("Improvement Targets:", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: greyText)),
          CustomText(pip.improvementTargets ?? "N/A", style: TextStyle(fontSize: 11.sp, color: blackText1)),
        ],
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
    Color color = status == 'active' ? Colors.blue : Colors.green;
    if (status == 'failed') color = Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(status), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionMenu(BuildContext context, PipModel pip) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert_rounded, size: 20, color: greyDart2),
      onSelected: (val) {
        if (val == 'edit') {
          navigate(context: context, page: AddPipScreen(pipModel: pip));
        } else if (val == 'delete') {
          _confirmDelete(context, pip);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Edit")])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_rounded, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete")])),
      ],
    );
  }

  void _confirmDelete(BuildContext context, PipModel pip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete PIP Record?"),
        content: Text("Are you sure you want to delete the PIP for ${pip.employeeName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<PipController>().deletePipRecord(pip.id!).then((res) {
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
