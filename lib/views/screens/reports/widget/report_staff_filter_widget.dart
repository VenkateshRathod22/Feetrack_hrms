import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/role_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class ReportStaffFilterWidget extends StatefulWidget {
  final Function(String search, String? departmentId, String? roleId) onFilterChanged;

  const ReportStaffFilterWidget({
    super.key,
    required this.onFilterChanged,
  });

  @override
  State<ReportStaffFilterWidget> createState() => _ReportStaffFilterWidgetState();
}

class _ReportStaffFilterWidgetState extends State<ReportStaffFilterWidget> {
  final TextEditingController searchController = TextEditingController();
  String? selectedDepartmentId;
  String? selectedRoleId;

  @override
  void initState() {
    super.initState();
    Get.find<DepartmentController>().getDepartmentList();
    Get.find<RoleController>().getRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.all(16.r),
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
          CustomText("Search", style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          sizedBoxHeight(height: 4),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Name or email...",
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
            ),
            onChanged: (val) => _applyFilter(),
          ),
          sizedBoxHeight(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText("Department", style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    sizedBoxHeight(height: 4),
                    GetBuilder<DepartmentController>(builder: (deptController) {
                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedDepartmentId,
                        hint: const Text("All Departments"),
                        decoration: _inputDecoration(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text("All Departments")),
                          ...deptController.departmentList.map((e) => DropdownMenuItem(
                                value: e.id.toString(),
                                child: Text(e.name ?? ""),
                              )),
                        ],
                        onChanged: (val) {
                          setState(() => selectedDepartmentId = val);
                          _applyFilter();
                        },
                      );
                    }),
                  ],
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText("Role", style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    sizedBoxHeight(height: 4),
                    GetBuilder<RoleController>(builder: (roleController) {
                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedRoleId,
                        hint: const Text("All Roles"),
                        decoration: _inputDecoration(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text("All Roles")),
                          ...roleController.roleList.map((e) => DropdownMenuItem(
                                value: e.id.toString(),
                                child: Text(e.name ?? ""),
                              )),
                        ],
                        onChanged: (val) {
                          setState(() => selectedRoleId = val);
                          _applyFilter();
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: primaryColor)),
    );
  }

  void _applyFilter() {
    widget.onFilterChanged(searchController.text, selectedDepartmentId, selectedRoleId);
  }
}
