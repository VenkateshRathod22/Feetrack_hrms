import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/expense_category_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddExpenceCategoryScreen extends StatefulWidget {
  final bool isEdit;
  final String? categoryId;
  const AddExpenceCategoryScreen({super.key, this.isEdit = false, this.categoryId});

  @override
  State<AddExpenceCategoryScreen> createState() => _AddExpenceCategoryScreenState();
}

class _AddExpenceCategoryScreenState extends State<AddExpenceCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Expense Category" : "Add Expense Category"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<ExpenseCategoryController>(builder: (controller) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  heading: "Category Name",
                  hindText: "Enter category name",
                  controller: controller.nameController,
                  isRequired: true,
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                CustomText(
                  "Type",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                sizedBoxHeight(height: 7.h),
                DropdownButtonFormField<String>(
                  value: controller.selectedType,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  ),
                  items: controller.types.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type == 'per_unit' ? 'Per Unit' : 'Fixed'),
                    );
                  }).toList(),
                  onChanged: (val) => controller.setType(val),
                ),
                sizedBoxHeight(height: 16.h),
                if (controller.selectedType == 'per_unit') ...[
                  AppTextFieldWithHeading(
                    heading: "Unit Name (e.g., KM, Hour)",
                    hindText: "Enter unit name",
                    controller: controller.unitNameController,
                    isRequired: true,
                    validator: (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  sizedBoxHeight(height: 16.h),
                  AppTextFieldWithHeading(
                    heading: "Rate Per Unit",
                    hindText: "Enter rate",
                    controller: controller.ratePerUnitController,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                ] else ...[
                  AppTextFieldWithHeading(
                    heading: "Max Limit Amount (Optional)",
                    hindText: "Enter max limit",
                    controller: controller.maxLimitController,
                    keyboardType: TextInputType.number,
                  ),
                ],
                sizedBoxHeight(height: 16.h),
                CustomText(
                  "Status",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                sizedBoxHeight(height: 7.h),
                DropdownButtonFormField<String>(
                  value: controller.selectedStatus,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  ),
                  items: controller.statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.capitalizeFirst!),
                    );
                  }).toList(),
                  onChanged: (val) => controller.setStatus(val),
                ),
                sizedBoxHeight(height: 32.h),
                CustomButton(
                  title: widget.isEdit ? "Update Category" : "Add Category",
                  isLoading: controller.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isEdit) {
                        controller.updateExpenseCategory(widget.categoryId!).then((res) {
                          showToast(message: res.message, typeCheck: res.isSuccess);
                          if (res.isSuccess) pop(context);
                        });
                      } else {
                        controller.createExpenseCategory().then((res) {
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
      }),
    );
  }
}
