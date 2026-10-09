import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/leave_category_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/settings/add_leave_category_screen.dart';

class LeaveCategoryScreen extends StatefulWidget {
  const LeaveCategoryScreen({super.key});

  @override
  State<LeaveCategoryScreen> createState() => _LeaveCategoryScreenState();
}

class _LeaveCategoryScreenState extends State<LeaveCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeaveCategoryController>().getLeaveCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Leave Category"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<LeaveCategoryController>().clearControllers();
          navigate(context: context, page: const AddLeaveCategoryScreen());
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: white),
      ),
      body: GetBuilder<LeaveCategoryController>(builder: (leaveCategoryController) {
        return Column(
          children: [
            Padding(
              padding: AppConstants.screenPadding.copyWith(bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search leave categories...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  leaveCategoryController.getLeaveCategories(search: val);
                },
              ),
            ),
            Expanded(
              child: leaveCategoryController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : leaveCategoryController.leaveCategoryList.isEmpty
                      ? const Center(child: CustomText("No leave categories found"))
                      : ListView.builder(
                          padding: AppConstants.screenPadding,
                          itemCount: leaveCategoryController.leaveCategoryList.length,
                          itemBuilder: (context, index) {
                            final category = leaveCategoryController.leaveCategoryList[index];
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
                                                color: (category.status ?? false)
                                                    ? Colors.green.withValues(alpha: 0.1)
                                                    : Colors.red.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4.r),
                                              ),
                                              child: CustomText(
                                                (category.status ?? false) ? "Active" : "Inactive",
                                                style: TextStyle(
                                                  color: (category.status ?? false) ? Colors.green : Colors.red,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sizedBoxHeight(height: 8.h),
                                        Row(
                                          children: [
                                            Icon(Icons.date_range, size: 16.sp, color: grey),
                                            sizedBoxWidth(width: 8.w),
                                            CustomText(
                                              (category.isUnlimited ?? false) ? "Unlimited" : "${category.days} Days",
                                              style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  sizedBoxWidth(width: 12.w),
                                  IconButton(
                                    onPressed: () {
                                      leaveCategoryController.setEditData(category);
                                      navigate(
                                        context: context,
                                        page: AddLeaveCategoryScreen(isEdit: true, categoryId: category.id),
                                      );
                                    },
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  sizedBoxWidth(width: 12.w),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteDialog(context, leaveCategoryController, category.id!);
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

  void _showDeleteDialog(BuildContext context, LeaveCategoryController controller, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Leave Category"),
        content: Text("Are you sure you want to delete this leave category?"),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteLeaveCategory(id).then((res) {
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
