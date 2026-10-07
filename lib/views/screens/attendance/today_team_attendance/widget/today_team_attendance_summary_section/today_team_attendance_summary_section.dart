import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/today_team_attendance/widget/today_team_attendance_summary_section/today_team_attendance_summary_widget.dart';

class TodayTeamAttendanceSummarySection extends StatefulWidget {
  const TodayTeamAttendanceSummarySection({
    super.key,
  });

  @override
  State<TodayTeamAttendanceSummarySection> createState() =>
      _TodayTeamAttendanceSummarySectionState();
}

class _TodayTeamAttendanceSummarySectionState
    extends State<TodayTeamAttendanceSummarySection> {
  bool isShowAllStatusData = true;

  void updateShowAllStatusData() {
    isShowAllStatusData = !isShowAllStatusData;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border:
                Border.all(width: 1, color: greyLight6.withValues(alpha: 0.30)),
            color: white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: black.withValues(alpha: 0.05),
              )
            ]),
        child: Column(
          children: [
            CustomText(
              "Today Team Attendance Summary",
              maxLines: 2,
              style: Helper(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 24.sp,
                    color: blackText3,
                  ),
            ),
            sizedBoxHeight(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: TodayTeamAttendanceSummaryWidget(
                    onTap: () {
                      updateShowAllStatusData();
                      attendanceController.fetchTodayTeamAttendance(
                          status: "punch_in",
                          isShowAllStatusData: isShowAllStatusData);
                    },
                    title: "Punch In",
                    subTitle: attendanceController
                            .employeesAttendanceSummaryModel?.punchIn
                            .toString() ??
                        "",
                    icon: Assets.svgsPunchIn,
                    color: punchIn,
                  ),
                ),
                Container(
                  width: 1,
                  height: 100.h,
                  color: greyLight2,
                ),
                Expanded(
                  child: TodayTeamAttendanceSummaryWidget(
                    onTap: () {
                      updateShowAllStatusData();
                      attendanceController.fetchTodayTeamAttendance(
                          status: "punch_out",
                          isShowAllStatusData: isShowAllStatusData);
                    },
                    title: "Punch out",
                    subTitle: attendanceController
                            .employeesAttendanceSummaryModel?.punchOut
                            .toString() ??
                        "",
                    icon: Assets.svgsLogout,
                    color: punchOut,
                  ),
                ),
                Container(
                  width: 1,
                  height: 100.h,
                  color: greyLight2,
                ),
                Expanded(
                  child: TodayTeamAttendanceSummaryWidget(
                    onTap: () {
                      updateShowAllStatusData();
                      attendanceController.fetchTodayTeamAttendance(
                          status: "absent",
                          isShowAllStatusData: isShowAllStatusData);
                    },
                    title: "Absent",
                    subTitle: attendanceController
                            .employeesAttendanceSummaryModel?.absent
                            .toString() ??
                        "",
                    icon: Assets.svgsAbsent,
                    color: absent,
                  ),
                ),
                Container(
                  width: 1,
                  height: 100.h,
                  color: greyLight2,
                ),
                Expanded(
                  child: TodayTeamAttendanceSummaryWidget(
                    onTap: () {
                      updateShowAllStatusData();
                      attendanceController.fetchTodayTeamAttendance(
                          status: "leave",
                          isShowAllStatusData: isShowAllStatusData);
                    },
                    title: "Leave",
                    subTitle: attendanceController
                            .employeesAttendanceSummaryModel?.absent
                            .toString() ??
                        "",
                    icon: Assets.svgsLeave,
                    color: leave,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
