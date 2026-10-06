import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/leave_category_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddLeaveCategoryScreen extends StatefulWidget {
  final bool isEdit;
  final int? categoryId;
  const AddLeaveCategoryScreen({super.key, this.isEdit = false, this.categoryId});

  @override
  State<AddLeaveCategoryScreen> createState() => _AddLeaveCategoryScreenState();
}

class _AddLeaveCategoryScreenState extends State<AddLeaveCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Leave Category" : "Add Leave Category"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<LeaveCategoryController>(builder: (leaveCategoryController) {
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
                  controller: leaveCategoryController.nameController,
                  isRequired: true,
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                sizedBoxHeight(height: 16.h),
                AppTextFieldWithHeading(
                  heading: "Days",
                  hindText: "Enter number of days",
                  controller: leaveCategoryController.daysController,
                  isRequired: !leaveCategoryController.isUnlimited,
                  readOnly: leaveCategoryController.isUnlimited,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (leaveCategoryController.isUnlimited) return null;
                    return val == null || val.isEmpty ? "Required" : null;
                  },
                ),
                sizedBoxHeight(height: 16.h),
                Row(
                  children: [
                    CustomText(
                      "Unlimited Days",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    Switch(
                      value: leaveCategoryController.isUnlimited,
                      onChanged: (val) {
                        leaveCategoryController.isUnlimited = val;
                        if (val) leaveCategoryController.daysController.text = "0";
                        leaveCategoryController.update();
                      },
                      activeColor: primaryColor,
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16.h),
                Row(
                  children: [
                    CustomText(
                      "Status",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    Switch(
                      value: leaveCategoryController.status,
                      onChanged: (val) {
                        leaveCategoryController.toggleStatus(val);
                      },
                      activeColor: primaryColor,
                    ),
                  ],
                ),
                sizedBoxHeight(height: 32.h),
                CustomButton(
                  title: widget.isEdit ? "Update Category" : "Add Category",
                  isLoading: leaveCategoryController.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isEdit) {
                        leaveCategoryController.updateLeaveCategory(widget.categoryId!).then((res) {
                          showToast(message: res.message, typeCheck: res.isSuccess);
                          if (res.isSuccess) pop(context);
                        });
                      } else {
                        leaveCategoryController.createLeaveCategory().then((res) {
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
