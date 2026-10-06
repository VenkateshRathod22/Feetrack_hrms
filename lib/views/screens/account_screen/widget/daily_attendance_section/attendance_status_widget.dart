import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';

class AttendanceStatusWidget extends StatelessWidget {
  const AttendanceStatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return CustomShimmer(
        isLoading: attendanceController.isLoading,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: greenDark2.withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(99.r),
          ),
          child: CustomText(
            capitalize(attendanceController.attendanceModel?.statusName ?? ""),
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14.sp,
                  color: greenDark2,
                ),
          ),
        ),
      );
    });
  }
}
