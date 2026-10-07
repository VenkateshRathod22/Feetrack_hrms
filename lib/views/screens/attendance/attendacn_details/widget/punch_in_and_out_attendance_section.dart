import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/dotted_line.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/attendacn_details/widget/punch_in_and_out_attendance_section/punch_in_and_out_icon_widget.dart';

class PunchInAndOutAttendanceDetailsSection extends StatelessWidget {
  const PunchInAndOutAttendanceDetailsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Container(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: black.withValues(alpha: 0.05),
              )
            ]),
        child: Row(
          children: [
            CustomShimmer(
              isLoading: attendanceController.isLoading,
              child: PunchInAndPunchOutIconWidget(
                time: convertTo12HourFormat(
                    time24: attendanceController.attendanceModel?.checkIn ?? "",
                    isShowAMPM: true),
                isCheckIn: true,
              ),
            ),
            const CircleAvatar(
              radius: 4,
              backgroundColor: green2,
            ),
            Expanded(
                child: DottedLine(
              color: grey,
            )),
            Icon(Icons.arrow_forward, color: grey),
            Expanded(
                child: DottedLine(
              color: grey,
            )),
            const CircleAvatar(
              radius: 4,
              backgroundColor: red1,
            ),
            CustomShimmer(
              isLoading: attendanceController.isLoading,
              child: PunchInAndPunchOutIconWidget(
                time: attendanceController.attendanceModel?.checkOutTimeFormat,
              ),
            ),
          ],
        ),
      );
    });
  }
}
