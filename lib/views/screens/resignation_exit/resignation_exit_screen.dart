import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/resignation_exit_controller.dart';
import 'package:vlr/data/models/exit_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/screens/resignation_exit/add_resignation_screen.dart';
import 'package:vlr/views/screens/resignation_exit/resignation_detail_screen.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class ResignationExitScreen extends StatefulWidget {
  const ResignationExitScreen({super.key});

  @override
  State<ResignationExitScreen> createState() => _ResignationExitScreenState();
}

class _ResignationExitScreenState extends State<ResignationExitScreen> {
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
    Get.find<ResignationExitController>().getExits();
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
    Get.find<ResignationExitController>().getExits(query: _getFilterData());
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
        title: CustomText("Resignations & Exits", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigate(context: context, page: const AddResignationScreen()),
        backgroundColor: primaryColor,
        icon:  Icon(Icons.exit_to_app_rounded, color: white),
        label: CustomText("Record Exit", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ),
      body: GetBuilder<ResignationExitController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () async {
              _applyFilters();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildFilterSection(),
                  if (controller.isLoading && controller.exitList.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.exitList.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: const Center(child: Text("No records found")),
                    )
                  else
                    ListView.separated(
                      padding: EdgeInsets.all(16.r),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.exitList.length,
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                      itemBuilder: (context, index) {
                        final exit = controller.exitList[index];
                        return _buildExitCard(context, exit);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
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

  Widget _buildExitCard(BuildContext context, ExitModel exit) {
    return GestureDetector(
      onTap: () => navigate(context: context, page: ResignationDetailScreen(exitId: exit.id!)),
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
                      CustomText(exit.employee?.name ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
                      CustomText(exit.employee?.employeeCode ?? "EMP-XXXX", style: TextStyle(fontSize: 11.sp, color: greyText)),
                    ],
                  ),
                ),
                _buildStatusBadge(exit.status),
                _buildActionMenu(context, exit),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem("Resignation Date", _formatDate(exit.resignationDate)),
                _infoItem("Last Working Day", _formatDate(exit.lastWorkingDate)),
              ],
            ),
            sizedBoxHeight(height: 12),
            const Divider(),
            sizedBoxHeight(height: 8),
            Row(
              children: [
                Icon(Icons.help_outline_rounded, size: 14.sp, color: greyText),
                sizedBoxWidth(width: 8),
                Expanded(
                  child: CustomText(exit.exitReason ?? "N/A", style: TextStyle(fontSize: 11.sp, color: greyDart2), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
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
    if (status == 'completed') color = Colors.green;
    if (status == 'in_notice_period') color = Colors.orange;
    if (status == 'resigned') color = Colors.deepPurple;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
      child: CustomText(capitalize(status?.replaceAll("_", " ")), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionMenu(BuildContext context, ExitModel exit) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert_rounded, size: 20, color: greyDart2),
      onSelected: (val) {
        if (val == 'edit') {
          navigate(context: context, page: AddResignationScreen(exitModel: exit));
        } else if (val == 'delete') {
          _confirmDelete(context, exit);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Edit")])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_rounded, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete")])),
      ],
    );
  }

  void _confirmDelete(BuildContext context, ExitModel exit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Exit Record?"),
        content: Text("Are you sure you want to delete the exit record for ${exit.employee?.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<ResignationExitController>().deleteExitRecord(exit.id!).then((res) {
                if (res.isSuccess) {
                  showToast(message: res.message, toastType: ToastType.success);
                } else {
                  showToast(message: res.message, toastType: ToastType.error);
                }
              });
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
