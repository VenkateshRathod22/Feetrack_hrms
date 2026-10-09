import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/expense_category_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/settings/add_expence_category_screen.dart';

class ExpenceCategoryScreen extends StatefulWidget {
  const ExpenceCategoryScreen({super.key});

  @override
  State<ExpenceCategoryScreen> createState() => _ExpenceCategoryScreenState();
}

class _ExpenceCategoryScreenState extends State<ExpenceCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ExpenseCategoryController>().getExpenseCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Expense Category"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<ExpenseCategoryController>().clearControllers();
          navigate(context: context, page: const AddExpenceCategoryScreen());
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: white),
      ),
      body: GetBuilder<ExpenseCategoryController>(builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: AppConstants.screenPadding.copyWith(bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search expense categories...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  controller.getExpenseCategories(search: val);
                },
              ),
            ),
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.expenseCategoryList.isEmpty
                      ? const Center(child: CustomText("No expense categories found"))
                      : ListView.builder(
                          padding: AppConstants.screenPadding,
                          itemCount: controller.expenseCategoryList.length,
                          itemBuilder: (context, index) {
                            final category = controller.expenseCategoryList[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: grey.withValues(alpha: 0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CustomText(
                                              category.name ?? "",
                                              style: Helper(context).textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                              decoration: BoxDecoration(
                                                color: category.status == "active"
                                                    ? Colors.green.withValues(alpha: 0.1)
                                                    : Colors.red.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4.r),
                                              ),
                                              child: CustomText(
                                                category.status?.capitalizeFirst ?? "",
                                                style: TextStyle(
                                                  color: category.status == "active" ? Colors.green : Colors.red,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sizedBoxHeight(height: 8.h),
                                        CustomText(
                                          "Type: ${category.type == 'per_unit' ? 'Per Unit' : 'Fixed'}",
                                          style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                        ),
                                        if (category.type == 'per_unit') ...[
                                          sizedBoxHeight(height: 4.h),
                                          CustomText(
                                            "Rate: ${category.ratePerUnit} per ${category.unitName}",
                                            style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                          ),
                                        ] else if (category.maxLimitAmount != null) ...[
                                          sizedBoxHeight(height: 4.h),
                                          CustomText(
                                            "Max Limit: ${category.maxLimitAmount}",
                                            style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  sizedBoxWidth(width: 12.w),
                                  IconButton(
                                    onPressed: () {
                                      controller.setEditData(category);
                                      navigate(
                                        context: context,
                                        page: AddExpenceCategoryScreen(isEdit: true, categoryId: category.id),
                                      );
                                    },
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  sizedBoxWidth(width: 12.w),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteDialog(context, controller, category.id!);
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, ExpenseCategoryController controller, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Expense Category"),
        content: Text("Are you sure you want to delete this expense category?"),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteExpenseCategory(id).then((res) {
                showToast(message: res.message, typeCheck: res.isSuccess);
                pop(context);
              });
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
