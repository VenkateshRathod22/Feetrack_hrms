import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/account_screen/widget/daily_attendance_section/punch_in_and_punch_out_widget.dart';

class CheckInandCheckOutWidgetTodayStatus extends StatelessWidget {
  const CheckInandCheckOutWidgetTodayStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                width: 1,
                color: greyLight6,
              ),
            ),
            child: CustomShimmer(
              isLoading: attendanceController.isLoading,
              child: PunchInAndPunchOutWidget(
                  title: "Punch In Time",
                  subTitle: (attendanceController.attendanceModel?.checkIn !=
                              null ||
                          (attendanceController
                                  .attendanceModel?.checkIn?.isNotEmpty ??
                              false))
                      ? convertTo12HourFormat(
                          time24:
                              attendanceController.attendanceModel?.checkIn ??
                                  "",
                          isShowAMPM: true,
                        )
                      : "-- : --"),
            ),
          ),
          sizedBoxWidth(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                width: 1,
                color: greyLight6,
              ),
            ),
            child: CustomShimmer(
              isLoading: attendanceController.isLoading,
              child: PunchInAndPunchOutWidget(
                title: "Punch out Time",
                subTitle: (attendanceController.attendanceModel?.checkOut !=
                        null)
                    ? convertTo12HourFormat(
                        time24:
                            attendanceController.attendanceModel?.checkOut ??
                                "",
                        isShowAMPM: true,
                      )
                    : "-- : --",
              ),
            ),
          ),
        ],
      );
    });
  }
}
