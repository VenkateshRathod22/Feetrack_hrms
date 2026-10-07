import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/staff_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/staff/staff_detail_screen.dart';
import 'package:vlr/views/screens/staff/create_staff_screen.dart';

class StaffWidget extends StatelessWidget {
  final StaffModel staff;
  final Function()? onTap;

  const StaffWidget({
    super.key,
    required this.staff,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return GestureDetector(
          onTap: onTap ??
                  () {
                Get.find<StaffController>().getStaffProfile(staff.id!);

                navigate(
                  context: context,
                  page: const StaffDetailScreen(),
                );
              },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 15,
                  spreadRadius: 0,
                  color: black.withValues(alpha: 0.05),
                ),
              ],
              border: Border.all(
                color: greyLight4,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // =========================
                // TOP IDENTITY SECTION
                // =========================
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.1),
                            width: 2,
                          ),
                        ),
                        child: CustomImage(
                          path: staff.profileImageUrl ?? "",
                          radius: 28.r,
                          height: 56.h,
                          width: 56.w,
                          fit: BoxFit.cover,
                        ),
                      ),

                      sizedBoxWidth(width: 14.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    staff.name ?? "N/A",
                                    style: Helper(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                      fontSize: 17.sp,
                                      color: blackText3,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                sizedBoxWidth(width: 8.w),

                                _buildStatusBadge(
                                  context,
                                  staff.employmentStatus,
                                ),
                              ],
                            ),

                            sizedBoxHeight(height: 2.h),

                            CustomText(
                              staff.role ?? "Employee",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color: greyLight4,
                ),

                // =========================
                // STAFF DETAILS
                // =========================
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // Employee ID + Joining Date
                      Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.badge_outlined,
                              "ID: ${staff.employeeCode ?? "N/A"}",
                            ),
                          ),

                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.calendar_today_outlined,
                              "Joined: ${staff.joiningDate ?? "N/A"}",
                            ),
                          ),
                        ],
                      ),

                      sizedBoxHeight(height: 12.h),

                      // Email + Mobile
                      Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.email_outlined,
                              staff.email ?? "N/A",
                            ),
                          ),

                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.phone_android_outlined,
                              staff.mobile ?? "N/A",
                            ),
                          ),
                        ],
                      ),

                      sizedBoxHeight(height: 12.h),

                      // Department + Manager
                      Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.work_outline,
                              staff.department?.name ?? "N/A",
                            ),
                          ),

                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.person_outline,
                              "Manager: ${staff.manager?.name ?? "N/A"}",
                            ),
                          ),
                        ],
                      ),

                      sizedBoxHeight(height: 12.h),

                      // Employment Type + Salary
                      Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.assignment_ind_outlined,
                              capitalize(
                                staff.employmentType ?? "N/A",
                              ),
                            ),
                          ),

                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.payments_outlined,
                              staff.basicSalary != null
                                  ? "₹${PriceConverter.convertToNumberFormat(
                                num.tryParse(
                                  staff.basicSalary!,
                                ) ??
                                    0,
                              )}"
                                  : "N/A",
                            ),
                          ),
                        ],
                      ),

                      sizedBoxHeight(height: 12.h),

                      // =========================
                      // WORK MODE
                      // =========================
                      Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              context,
                              Icons.home_work_outlined,
                              "Work Mode: ${capitalize(staff.workingMode ?? "N/A")}",
                            ),
                          ),

                          // Empty space to keep layout aligned
                          const Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =========================
                // FOOTER
                // =========================
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: greyLight1.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: greyLight8,
                      ),

                      sizedBoxWidth(width: 4.w),

                      Expanded(
                        child: CustomText(
                          "${staff.branch?.name ?? "N/A"} | "
                              "${staff.shift?.name ?? "N/A"}",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: greyLight8,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Row(
                        children: [
                          if (authController.hasPermission("staff_update"))
                            _ActionButton(
                              icon: Icons.edit_note_rounded,
                              color: primaryColor,
                              onPressed: () {
                                Get.find<StaffController>()
                                    .setEditData(staff);

                                navigate(
                                  context: context,
                                  page: const CreateStaffScreen(
                                    isEdit: true,
                                  ),
                                );
                              },
                            ),

                          if (authController.hasPermission("staff_update") &&
                              authController.hasPermission("staff_delete"))
                            sizedBoxWidth(width: 8.w),

                          if (authController.hasPermission("staff_delete"))
                            _ActionButton(
                              icon: Icons.delete_outline_rounded,
                              color: red1,
                              onPressed: () =>
                                  _showDeleteDialog(context),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================
  // INFO ITEM
  // =========================
  Widget _infoItem(
      BuildContext context,
      IconData icon,
      String value,
      ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 14.sp,
            color: primaryColor,
          ),
        ),

        sizedBoxWidth(width: 8.w),

        Expanded(
          child: CustomText(
            value,
            style: Helper(context).textTheme.bodySmall?.copyWith(
              color: blackText3,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // =========================
  // STATUS BADGE
  // =========================
  Widget _buildStatusBadge(
      BuildContext context,
      String? status,
      ) {
    Color statusColor = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 12.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: statusColor.withValues(alpha: 0.1),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: CustomText(
        capitalize(status ?? "unknown"),
        style: TextStyle(
          fontSize: 10.sp,
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================
  // STATUS COLOR
  // =========================
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return green;

      case 'inactive':
        return greyDart2;

      case 'on_leave':
        return yellow;

      case 'resigned':
        return red1;

      case 'terminated':
        return black;

      default:
        return grey;
    }
  }

  // =========================
  // DELETE DIALOG
  // =========================
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: const Text("Delete Staff"),
        content: const Text(
          "Are you sure you want to delete this staff member?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () {
              final nav = Navigator.of(context);

              Get.find<StaffController>()
                  .deleteStaff(staff.id!)
                  .then((response) {
                if (response.isSuccess) {
                  showToast(
                    message: response.message,
                    toastType: ToastType.success,
                  );
                } else {
                  showToast(
                    message: response.message,
                    toastType: ToastType.error,
                  );
                }

                nav.pop();
              });
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: red1,
              ),
            ),
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
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.sp, color: color),
        ),
      ),
    );
  }
}
