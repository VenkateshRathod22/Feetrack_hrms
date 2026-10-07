import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/category_controller.dart';
import 'package:vlr/data/models/category_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/category/create_category_screen.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: black.withValues(alpha: 0.05),
          )
        ],
        border: Border.all(color: greyLight1, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      category.name ?? "Unknown Category",
                      style: Helper(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16.sp,
                            color: blackText3,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    sizedBoxHeight(height: 4.h),
                    _buildStatusBadge(context, category.status),
                  ],
                ),
              ),
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.edit_outlined,
                    color: primaryColor,
                    onPressed: () {
                      Get.find<CategoryController>().setEditData(category);
                      navigate(context: context, page: CreateCategoryScreen(category: category, isEdit: true));
                    },
                  ),
                  sizedBoxWidth(width: 8.w),
                  _ActionButton(
                    icon: Icons.delete_outline,
                    color: red1,
                    onPressed: () => _showDeleteDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String? status) {
    Color statusColor = status?.toLowerCase() == 'active' ? green : red1;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: statusColor.withValues(alpha: 0.1),
      ),
      child: CustomText(
        capitalize(status ?? "unknown"),
        style: Helper(context).textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final nav = Navigator.of(context);
              Get.find<CategoryController>().deleteCategory(category.id!).then((response) {
                if (response.isSuccess) {
                  showToast(message: response.message, toastType: ToastType.success);
                } else {
                  showToast(message: response.message, toastType: ToastType.error);
                }
                nav.pop();
              });
            },
            child: const Text("Delete", style: TextStyle(color: red1)),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
          child: Icon(icon, size: 18.sp, color: color),
        ),
      ),
    );
  }
}
