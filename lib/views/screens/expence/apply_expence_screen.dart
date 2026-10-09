import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/expense_controller.dart';
import 'package:vlr/data/models/response/expense_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';
import 'package:vlr/views/screens/expence/expence_history_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/data/models/expense_category_model.dart';

class ApplyExpenceScreen extends StatefulWidget {
  final ExpenseModel? expense;
  const ApplyExpenceScreen({super.key, this.expense});

  @override
  State<ApplyExpenceScreen> createState() => _ApplyExpenceScreenState();
}

class _ApplyExpenceScreenState extends State<ApplyExpenceScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ExpenseController>().fetchExpenseCategories();
      if (widget.expense != null) {
        Get.find<ExpenseController>().setExpense(widget.expense!);
      } else {
        Get.find<ExpenseController>().clearFields();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<ExpenseController>(builder: (expenseController) {
              return CustomButton(
                height: 50,
                isLoading: expenseController.isLoading,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    if (expenseController.selectedExpense != null) {
                      expenseController.updateExpense();
                    } else {
                      expenseController.submitExpense();
                    }
                  }
                },
                child: CustomText(
                  expenseController.selectedExpense != null ? "Update Expense" : "Submit Expense",
                  style: Helper(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 16.sp, color: white),
                ),
              );
            })
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: white,
        title: CustomText(
          widget.expense != null ? "Edit Expense" : "Apply for Expense",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
        actions: [
          if (widget.expense == null)
            IconButton(
              onPressed: () {
                navigate(context: context, page: const ExpenceHistoryScreen());
              },
              icon: Icon(Icons.history),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: GetBuilder<ExpenseController>(builder: (expenseController) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                AppTextFieldWithHeading(
                  headingWidget: Row(
                    children: [
                      CustomText(
                        "Amount",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                      ),
                      CustomText(
                        " *",
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 18.sp, color: redDark),
                      ),
                    ],
                  ),
                  controller: expenseController.amountController,
                  hindText: "Enter amount",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter amount";
                    }
                    return null;
                  },
                ),
                sizedBoxHeight(height: 24.h),
                CustomDropDownList<ExpenseCategoryModel>(
                  headingWidget: Row(
                    children: [
                      CustomText(
                        "Category",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                      ),
                      CustomText(
                        " *",
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 18.sp, color: redDark),
                      ),
                    ],
                  ),
                  value: expenseController.selectedCategory,
                  items: expenseController.expenseCategoryList,
                  hintText: "Select category",
                  onChanged: (value) {
                    expenseController.selectedCategory = value;
                    expenseController.update();
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Select category";
                    }
                    return null;
                  },
                ),
                sizedBoxHeight(height: 24.h),
                AppTextFieldWithHeading(
                  headingWidget: Row(
                    children: [
                      CustomText(
                        "Date",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                      ),
                      CustomText(
                        " *",
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 18.sp, color: redDark),
                      ),
                    ],
                  ),
                  controller: expenseController.dateController,
                  hindText: "dd-mm-yyyy",
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      expenseController.dateController.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-"
                          "${pickedDate.month.toString().padLeft(2, '0')}-"
                          "${pickedDate.year}";
                    }
                  },
                  suffix: Icon(Icons.calendar_month),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select date";
                    }
                    return null;
                  },
                ),
                sizedBoxHeight(height: 24.h),
                AppTextFieldWithHeading(
                  headingWidget: Row(
                    children: [
                      CustomText(
                        "Description",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                      ),
                    ],
                  ),
                  controller: expenseController.descriptionController,
                  hindText: "Enter description...",
                  maxLines: 5,
                ),
                sizedBoxHeight(height: 24.h),
                _buildImagePickerSection(context, expenseController),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImagePickerSection(BuildContext context, ExpenseController expenseController) {
    bool hasExistingImage = expenseController.selectedExpense?.uploadFile != null &&
        expenseController.selectedExpense!.uploadFile!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Upload Receipt",
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
        ),
        sizedBoxHeight(height: 12),
        GestureDetector(
          onTap: () => expenseController.showImagePicker(context),
          child: Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: greyLight1),
            ),
            child: expenseController.pickedFile != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.file(
                          expenseController.pickedFile!,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            expenseController.pickedFile = null;
                            expenseController.update();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : hasExistingImage
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: CachedNetworkImage(
                              imageUrl: expenseController.selectedExpense!.uploadFile!,
                              height: 150.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: CustomText(
                                "Tap to change",
                                style: TextStyle(color: white, fontSize: 10.sp),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded, size: 40.sp, color: greyDart2),
                          sizedBoxHeight(height: 8),
                          CustomText(
                            "Tap to select image",
                            style: Helper(context).textTheme.bodySmall?.copyWith(color: greyDart2),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}
