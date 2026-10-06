import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/role_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/controllers/work_shift_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

import '../edit_profile/profile_detail_screen.dart';

class CreateStaffScreen extends StatefulWidget {
  final bool isEdit;
  const CreateStaffScreen({super.key, this.isEdit = false});

  @override
  State<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends State<CreateStaffScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RoleController>().getRoles();
      Get.find<DepartmentController>().getDepartmentList();
      Get.find<BrachesController>().getBranchesList();
      Get.find<WorkShiftController>().getWorkShifts();
      Get.find<StaffController>().getEmployeesListing();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Staff" : "Create Staff"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<StaffController>(builder: (staffController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: (){
                      navigate(context: context, page: ProfileDetailScreen());
                    },
                    child: _buildSectionTitle("Personal Information")),
                AppTextFieldWithHeading(
                  heading: "Name",
                  hindText: "Enter Name",
                  controller: staffController.nameController,
                  keyboardType: TextInputType.name,
                  isRequired: true,
                  validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Email",
                  hindText: "Enter Email",
                  controller: staffController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                  validator: (value) => value == null || !value.isEmail ? "Valid email is required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Mobile",
                  hindText: "Enter Mobile",
                  controller: staffController.mobileController,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                  validator: (value) => value == null || value.isEmpty ? "Mobile is required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                if (!widget.isEdit) ...[
                  AppTextFieldWithHeading(
                    heading: "Password",
                    hindText: "Enter Password",
                    controller: staffController.passwordController,
                    obscureText: true,
                    isRequired: true,
                    validator: (value) => value == null || value.length < 8 ? "Password must be at least 8 chars" : null,
                  ),
                  sizedBoxHeight(height: 16.h),
                ],
                _buildSectionTitle("Work Details"),
                AppTextFieldWithHeading(
                  heading: "Employee Code",
                  hindText: "Enter Employee Code",
                  controller: staffController.employeeCodeController,
                  isRequired: true,
                  validator: (value) => value == null || value.isEmpty ? "Code is required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Basic Salary",
                  hindText: "Enter Basic Salary",
                  controller: staffController.basicSalaryController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Joining Date",
                  hindText: "YYYY-MM-DD",
                  controller: staffController.joiningDateController,
                  keyboardType: TextInputType.datetime,
                ),
                sizedBoxHeight(height: 16.h),
                _buildSectionTitle("Organization IDs"),
                GetBuilder<RoleController>(builder: (roleController) {
                  return _buildDropdown(
                    "Role",
                    staffController.selectedRoleId,
                    roleController.roleList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                    (val) => setState(() => staffController.selectedRoleId = val),
                  );
                }),
                sizedBoxHeight(height: 16.h),
                GetBuilder<DepartmentController>(builder: (deptController) {
                  return _buildDropdown(
                    "Department",
                    staffController.selectedDepartmentId,
                    deptController.departmentList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                    (val) => setState(() => staffController.selectedDepartmentId = val),
                  );
                }),
                sizedBoxHeight(height: 16.h),
                GetBuilder<BrachesController>(builder: (branchController) {
                  return _buildDropdown(
                    "Branch",
                    staffController.selectedBranchId,
                    branchController.branchList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                    (val) => setState(() => staffController.selectedBranchId = val),
                  );
                }),
                sizedBoxHeight(height: 16.h),
                GetBuilder<WorkShiftController>(builder: (shiftController) {
                  return _buildDropdown(
                    "Shift",
                    staffController.selectedShiftId,
                    shiftController.workShiftList.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                    (val) => setState(() => staffController.selectedShiftId = val),
                  );
                }),
                sizedBoxHeight(height: 16.h),
                _buildDropdown(
                  "Assign To",
                  staffController.selectedReportingToId,
                  staffController.employeeListing.map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""))).toList(),
                  (val) => setState(() => staffController.selectedReportingToId = val),
                ),
                sizedBoxHeight(height: 16.h),
                if (widget.isEdit) ...[
                  _buildSectionTitle("Status"),
                  _buildDropdown(
                    "Employment Status",
                    staffController.selectedEmploymentStatus,
                    ['active', 'on_leave', 'resigned', 'terminated'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                    (val) => setState(() => staffController.selectedEmploymentStatus = val),
                  ),
                  sizedBoxHeight(height: 16.h),
                  _buildDropdown(
                    "System Status",
                    staffController.selectedStatus,
                    ['active', 'inactive'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                    (val) => setState(() => staffController.selectedStatus = val),
                  ),
                  sizedBoxHeight(height: 24.h),
                ],
                CustomButton(
                  title: widget.isEdit ? "Update Staff" : "Create Staff",
                  isLoading: staffController.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isEdit) {
                        staffController.updateStaff(staffController.staffProfile!.id!).then((response) {
                          if (response.isSuccess) {
                            showToast(message: response.message, toastType: ToastType.success);
                            pop(context);
                          } else {
                            showToast(message: response.message, toastType: ToastType.error);
                          }
                        });
                      } else {
                        staffController.createStaff().then((response) {
                          if (response.isSuccess) {
                            showToast(message: response.message, toastType: ToastType.success);
                            pop(context);
                          } else {
                            showToast(message: response.message, toastType: ToastType.error);
                          }
                        });
                      }
                    }
                  },
                ),
                sizedBoxHeight(height: 30.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: CustomText(
        title,
        style: Helper(context).textTheme.titleMedium?.copyWith(color: primaryColor),
      ),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          hint,
          style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        sizedBoxHeight(height: 7.h),
        DropdownButtonFormField<String>(
          isExpanded: true,
          dropdownColor: white,
          value: (value != null && items.any((item) => item.value == value)) ? value : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: grey.withValues(alpha: 0.5), width: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
