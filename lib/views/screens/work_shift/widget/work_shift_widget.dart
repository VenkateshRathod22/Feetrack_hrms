import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/work_shift_controller.dart';
import 'package:vlr/data/models/work_shift_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/work_shift/create_work_shift_screen.dart';

class WorkShiftWidget extends StatelessWidget {
  final WorkShiftModel shift;
  const WorkShiftWidget({super.key, required this.shift});

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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.access_time, color: primaryColor, size: 24.sp),
                  ),
                  sizedBoxWidth(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          shift.name ?? "Unknown Shift",
                          style: Helper(context).textTheme.titleMedium?.copyWith(
                                fontSize: 16.sp,
                                color: blackText3,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        sizedBoxHeight(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.login, size: 14.sp, color: green),
                            sizedBoxWidth(width: 4.w),
                            CustomText(
                              shift.startTime ?? "N/A",
                              style: Helper(context).textTheme.bodySmall?.copyWith(color: blackText1),
                            ),
                            sizedBoxWidth(width: 12.w),
                            Icon(Icons.logout, size: 14.sp, color: red1),
                            sizedBoxWidth(width: 4.w),
                            CustomText(
                              shift.endTime ?? "N/A",
                              style: Helper(context).textTheme.bodySmall?.copyWith(color: blackText1),
                            ),
                          ],
                        ),
                        if (shift.weekOffDays != null && shift.weekOffDays!.isNotEmpty) ...[
                          sizedBoxHeight(height: 8.h),
                          Wrap(
                            spacing: 4.w,
                            children: shift.weekOffDays!.map((day) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: greyLight4,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: CustomText(
                                day.substring(0, 3),
                                style: Helper(context).textTheme.bodySmall?.copyWith(fontSize: 10.sp),
                              ),
                            )).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
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
                      Get.find<WorkShiftController>().setEditData(shift);
                      navigate(context: context, page: CreateWorkShiftScreen(shift: shift, isEdit: true));
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
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Work Shift"),
        content: Text("Are you sure you want to delete this work shift?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final nav = Navigator.of(context);
              Get.find<WorkShiftController>().deleteWorkShift(shift.id!).then((response) {
                if (response.isSuccess) {
                  showToast(message: response.message, toastType: ToastType.success);
                } else {
                  showToast(message: response.message, toastType: ToastType.error);
                }
                nav.pop();
              });
            },
            child: Text("Delete", style: TextStyle(color: red1)),
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
