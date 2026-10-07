import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/role_controller.dart';
import 'package:vlr/data/models/role_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/role/create_role_screen.dart';
import 'package:vlr/views/screens/role/role_detail_screen.dart';

import '../update_role_screen.dart';

class RoleWidget extends StatelessWidget {
  final RoleModel role;
  const RoleWidget({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    String displayName = role.name ?? "Unknown Role";
    if (displayName.contains("_")) {
      displayName = displayName.split("_").last;
    }

    return GestureDetector(
      onTap: () {
        Get.find<RoleController>().getRoleDetails(role.id!);
        navigate(context: context, page: RoleDetailScreen(role: role));
      },
      child: Container(
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.security, color: primaryColor, size: 24.sp),
                    ),
                    sizedBoxWidth(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            displayName,
                            style: Helper(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 16.sp,
                                  color: blackText3,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          sizedBoxHeight(height: 4.h),
                          CustomText(
                            "Permissions: ${role.permissionsCount ?? 0}",
                            style: Helper(context).textTheme.bodySmall?.copyWith(color: greyText),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14.sp, color: greyLight5),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: greyLight4.withValues(alpha: 0.5),
                  border: Border(top: BorderSide(color: greyLight1, width: 1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      color: primaryColor,
                      onPressed: () {
                        navigate(context: context, page: UpdateRoleScreen(role: role));
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Role"),
        content: const Text("Are you sure you want to delete this role?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final nav = Navigator.of(context);
              Get.find<RoleController>().deleteRole(role.id!).then((response) {
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
