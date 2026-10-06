import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/work_shift_controller.dart';
import 'package:vlr/data/models/work_shift_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateWorkShiftScreen extends StatefulWidget {
  final bool isEdit;
  final WorkShiftModel? shift;
  const CreateWorkShiftScreen({super.key, this.isEdit = false, this.shift});

  @override
  State<CreateWorkShiftScreen> createState() => _CreateWorkShiftScreenState();
}

class _CreateWorkShiftScreenState extends State<CreateWorkShiftScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BrachesController>().getBranchesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Work Shift" : "Create Work Shift"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<WorkShiftController>(builder: (controller) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Basic Information"),
                AppTextFieldWithHeading(
                  heading: "Shift Name",
                  hindText: "Enter Shift Name",
                  controller: controller.nameController,
                  isRequired: true,
                  validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "Start Time",
                        hindText: "HH:MM",
                        controller: controller.startTimeController,
                        isRequired: true,
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                      ),
                    ),
                    sizedBoxWidth(width: 16.w),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        heading: "End Time",
                        hindText: "HH:MM",
                        controller: controller.endTimeController,
                        isRequired: true,
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16.h),
                GetBuilder<BrachesController>(builder: (branchController) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Branch",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      sizedBoxHeight(height: 7.h),
                      DropdownButtonFormField<int>(
                        value: controller.selectedBranchId,
                        decoration: _inputDecoration(),
                        hint: const Text("Select Branch"),
                        items: branchController.branchList
                            .map((e) => DropdownMenuItem<int>(
                                  value: e.id,
                                  child: Text(e.name ?? ""),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => controller.selectedBranchId = val),
                      ),
                    ],
                  );
                }),
                sizedBoxHeight(height: 24.h),
                _buildSectionTitle("Attendance Configuration"),
                Row(
                  children: [
                    Checkbox(
                      value: controller.autoMarkAttendance,
                      onChanged: (val) => setState(() => controller.autoMarkAttendance = val ?? false),
                      activeColor: primaryColor,
                    ),
                    CustomText("Auto Mark Attendance", style: Helper(context).textTheme.bodyMedium),
                  ],
                ),
                sizedBoxHeight(height: 8.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Auto Mark Status",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    sizedBoxHeight(height: 7.h),
                    DropdownButtonFormField<String>(
                      value: controller.selectedAutoMarkStatus,
                      decoration: _inputDecoration(),
                      items: ['present', 'absent', 'half_day']
                          .map((e) => DropdownMenuItem<String>(value: e, child: Text(capitalize(e))))
                          .toList(),
                      onChanged: (val) => setState(() => controller.selectedAutoMarkStatus = val!),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Late Tolerance (Mins)",
                  hindText: "Enter Minutes",
                  controller: controller.lateToleranceController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Min Present (Mins)",
                  hindText: "Enter Minutes",
                  controller: controller.minPresentController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Min Half Day (Mins)",
                  hindText: "Enter Minutes",
                  controller: controller.minHalfDayController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Auto Absent Mark (Mins)",
                  hindText: "Enter Minutes",
                  controller: controller.autoAbsentMarkController,
                  keyboardType: TextInputType.number,
                ),
                sizedBoxHeight(height: 24.h),
                _buildSectionTitle("Week Off Days"),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: controller.daysOfWeek.map((day) {
                    bool isSelected = controller.selectedWeekOffDays.contains(day);
                    return FilterChip(
                      label: Text(day),
                      selected: isSelected,
                      onSelected: (_) => controller.toggleWeekOffDay(day),
                      selectedColor: primaryColor.withValues(alpha: 0.2),
                      checkmarkColor: primaryColor,
                      labelStyle: TextStyle(color: isSelected ? primaryColor : blackText1),
                    );
                  }).toList(),
                ),
                sizedBoxHeight(height: 32.h),
                CustomButton(
                  title: widget.isEdit ? "Update Shift" : "Create Shift",
                  isLoading: controller.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final nav = Navigator.of(context);
                      if (widget.isEdit) {
                        controller.updateWorkShift(widget.shift!.id!).then((response) {
                          if (response.isSuccess) {
                            showToast(message: response.message, toastType: ToastType.success);
                            nav.pop();
                          } else {
                            showToast(message: response.message, toastType: ToastType.error);
                          }
                        });
                      } else {
                        controller.createWorkShift().then((response) {
                          if (response.isSuccess) {
                            showToast(message: response.message, toastType: ToastType.success);
                            nav.pop();
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
        style: Helper(context).textTheme.titleMedium?.copyWith(color: primaryColor, fontSize: 18.sp),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
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
    );
  }
}
