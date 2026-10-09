import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateDepartmentScreen extends StatefulWidget {
  final bool isEdit;
  final int? departmentId;
  const CreateDepartmentScreen({super.key, this.isEdit = false, this.departmentId});

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBranchId;
  String? _branchZone;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BrachesController>().getBranchesList();
      Get.find<StaffController>().getEmployeesListing();
      Get.find<DepartmentController>().getDepartmentList();
      if (widget.isEdit && widget.departmentId != null) {
        // Handle edit data if needed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Department" : "Create Department"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<DepartmentController>(builder: (deptController) {
        return GetBuilder<BrachesController>(builder: (branchController) {
          return GetBuilder<StaffController>(builder: (staffController) {
            return SingleChildScrollView(
              padding: AppConstants.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextFieldWithHeading(
                      heading: "Department Name",
                      hindText: "Enter name",
                      controller: deptController.nameController,
                      isRequired: true,
                      validator: (val) => val == null || val.isEmpty ? "Required" : null,
                    ),
                    sizedBoxHeight(height: 16.h),
                    AppTextFieldWithHeading(
                      heading: "Description",
                      hindText: "Enter description",
                      controller: deptController.descriptionController,
                      maxLines: 3,
                    ),
                    sizedBoxHeight(height: 16.h),
                    _buildDropdown(
                      "Parent Department",
                      deptController.selectedParentId?.toString(),
                      deptController.departmentList
                          .where((dept) => dept.id != widget.departmentId)
                          .map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? "")))
                          .toList(),
                      (val) => setState(() => deptController.selectedParentId = int.tryParse(val!)),
                    ),
                    sizedBoxHeight(height: 24.h),
                    CustomText(
                      "Branch Zone (Mapping)",
                      style: Helper(context).textTheme.titleMedium?.copyWith(color: primaryColor),
                    ),
                    sizedBoxHeight(height: 8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            "Branch",
                            _selectedBranchId,
                            staffController.employeeListing.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                            (val) => setState(() => _selectedBranchId = val),
                          ),
                        ),
                        sizedBoxWidth(width: 8.w),
                        Expanded(
                          child: _buildDropdown(
                            "Branch (Zone)",
                            _branchZone,
                            staffController.employeeListing.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                            (val) => setState(() => _branchZone = val),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: IconButton(
                            onPressed: () {
                              if (_selectedBranchId != null && _branchZone != null) {
                                deptController.addBranchHead(_selectedBranchId!, _branchZone!);
                                setState(() {
                                  _selectedBranchId = null;
                                  _branchZone = null;
                                });
                              }
                            },
                            icon:  Icon(Icons.add_circle, color: green2, size: 30),
                          ),
                        ),
                      ],
                    ),

                    sizedBoxHeight(height: 8.h),

                    Wrap(
                      spacing: 8.w,
                      children: deptController.branchHeads.entries.map((entry) {
                        final branchStaff = staffController.employeeListing.firstWhereOrNull((e) => e.id.toString() == entry.key);
                        final zoneStaff = staffController.employeeListing.firstWhereOrNull((e) => e.id.toString() == entry.value);
                        return Chip(
                          label: Text("${branchStaff?.name ?? entry.key} -> ${zoneStaff?.name ?? entry.value}"),
                          onDeleted: () => deptController.removeBranchHead(entry.key),
                          deleteIconColor: red1,
                        );
                      }).toList(),
                    ),
                    sizedBoxHeight(height: 32.h),
                    CustomButton(
                      title: widget.isEdit ? "Update Department" : "Create Department",
                      isLoading: deptController.isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.isEdit) {
                            deptController.updateDepartment(widget.departmentId!).then((res) {
                              showToast(message: res.message, typeCheck: res.isSuccess);
                              if (res.isSuccess) pop(context);
                            });
                          } else {
                            deptController.createDepartment().then((res) {
                              showToast(message: res.message, typeCheck: res.isSuccess);
                              if (res.isSuccess) pop(context);
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
      }),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          hint,
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        sizedBoxHeight(height: 4.h),
        DropdownButtonFormField<String>(
          isExpanded: true,
          dropdownColor: white,
          value: (value != null && items.any((item) => item.value == value)) ? value : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
