import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class WorkingHoursRow extends StatelessWidget {
  const WorkingHoursRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      if ((attendanceController.attendanceModel?.isPunchOut ?? false) ||
          (attendanceController.attendanceModel?.isHalfDay ?? false)) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Working Hours",
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      color: greyDart2,
                    ),
              ),
              CustomText(
                attendanceController.attendanceModel?.workingTimeFormat ?? "",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      color: blackText1,
                    ),
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }
}
