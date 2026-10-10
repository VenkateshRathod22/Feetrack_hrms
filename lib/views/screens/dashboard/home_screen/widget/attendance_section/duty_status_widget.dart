import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class DutyStatusWidget extends StatelessWidget {
  const DutyStatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color:  attendanceController.attendanceModel?.statusColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(width: 1, color: attendanceController.attendanceModel?.statusColor ?? primaryColor,),),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 4.r,
              backgroundColor: attendanceController.attendanceModel?.statusColor ?? primaryColor,
            ),
            sizedBoxWidth(width: 8.w),
            CustomText(
           attendanceController.attendanceModel?.statusText ?? "",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12.sp,
                    color: attendanceController.attendanceModel?.statusColor ?? primaryColor,
                  ),
            ),
          ],
        ),
      );
    });
  }
}
