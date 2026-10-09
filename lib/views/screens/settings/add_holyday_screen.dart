import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/holiday_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddHolydayScreen extends StatefulWidget {
  final bool isEdit;
  final int? holidayId;
  const AddHolydayScreen({super.key, this.isEdit = false, this.holidayId});

  @override
  State<AddHolydayScreen> createState() => _AddHolydayScreenState();
}

class _AddHolydayScreenState extends State<AddHolydayScreen> {
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
        title: Text(widget.isEdit ? "Edit Holiday" : "Add Holiday"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<HolidayController>(builder: (holidayController) {
        return GetBuilder<BrachesController>(builder: (branchController) {
          return SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFieldWithHeading(
                    heading: "Holiday Name",
                    hindText: "Enter holiday name",
                    controller: holidayController.nameController,
                    isRequired: true,
                    validator: (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  sizedBoxHeight(height: 16.h),
                  AppTextFieldWithHeading(
                    heading: "Date",
                    hindText: "YYYY-MM-DD",
                    controller: holidayController.dateController,
                    isRequired: true,
                    readOnly: true,
                    suffix: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        holidayController.dateController.text = picked.toString().split(' ')[0];
                      }
                    },
                    validator: (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  sizedBoxHeight(height: 16.h),
                  _buildDropdown(
                    "Branch",
                    holidayController.selectedBranchId,
                    branchController.branchList
                        .map((e) => DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? "")))
                        .toList(),
                    (val) => setState(() => holidayController.selectedBranchId = val),
                  ),
                  sizedBoxHeight(height: 32.h),
                  CustomButton(
                    title: widget.isEdit ? "Update Holiday" : "Add Holiday",
                    isLoading: holidayController.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.isEdit) {
                          holidayController.updateHoliday(widget.holidayId!).then((res) {
                            showToast(message: res.message, typeCheck: res.isSuccess);
                            if (res.isSuccess) pop(context);
                          });
                        } else {
                          holidayController.addHoliday().then((res) {
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
