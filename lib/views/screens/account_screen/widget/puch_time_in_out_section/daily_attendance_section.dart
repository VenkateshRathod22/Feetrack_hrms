import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/account_screen/widget/daily_attendance_section/attendance_status_widget.dart';
import 'package:vlr/views/screens/account_screen/widget/daily_attendance_section/daily_top_mid_section.dart';
import 'package:vlr/views/screens/account_screen/widget/daily_attendance_section/punch_out_button.dart';
import 'package:vlr/views/screens/account_screen/widget/daily_attendance_section/working_hours_row.dart';
import 'package:vlr/views/screens/account_screen/widget/puch_time_in_out_section/punch_time_in_out_section.dart';
import 'package:vlr/views/screens/attendance/attendance_mart_screen/attendance_mart_screen.dart';

class DailyAttendanceSection extends StatelessWidget {
  const DailyAttendanceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return CustomShimmer(
        isLoading: attendanceController.isLoading,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.r),
            border: const Border(left: BorderSide(width: 4, color: greenDark)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: black.withValues(
                  alpha: 0.05,
                ),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*. status section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    "Daily Attendance",
                    style: Helper(context).textTheme.labelMedium?.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  attendanceController.attendanceModel?.isPunchIn ?? false
                      ? const AttendanceStatusWidget()
                      : const SizedBox(),
                ],
              ),

              //*  top med section

              const DailyTopMidSection(),

              //* Punch in and Punch out section
              const PunchTimeInOutSection(),
              const WorkingHoursRow(),
              PunchButtonWidget(
                onTap: () {
                  navigate(
                      context: context, page: const AttendanceMartScreen());
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
