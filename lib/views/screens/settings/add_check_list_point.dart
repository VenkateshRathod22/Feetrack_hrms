import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_checklist_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddCheckListPoint extends StatefulWidget {
  const AddCheckListPoint({super.key});

  @override
  State<AddCheckListPoint> createState() => _AddCheckListPointState();
}

class _AddCheckListPointState extends State<AddCheckListPoint> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Add Checklist Point"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<AttendanceChecklistController>(builder: (controller) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  heading: "QUESTION",
                  hindText: "e.g. Are you wearing ID card?",
                  controller: controller.questionController,
                  isRequired: true,
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 24.h),
                _buildDropdown(
                  "DISPLAY MODE",
                  controller.selectedMode,
                  controller.modeList.map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e.replaceAll('_', ' '))))).toList(),
                  (val) => setState(() => controller.selectedMode = val!),
                ),
                sizedBoxHeight(height: 8.h),
                CustomText(
                  "Choose when this question should be shown to employees.",
                  style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                ),
                sizedBoxHeight(height: 32.h),
                CustomButton(
                  title: "Add Question",
                  isLoading: controller.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.addChecklist().then((res) {
                        showToast(message: res.message, typeCheck: res.isSuccess);
                        if (res.isSuccess) pop(context);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
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
          value: value,
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
