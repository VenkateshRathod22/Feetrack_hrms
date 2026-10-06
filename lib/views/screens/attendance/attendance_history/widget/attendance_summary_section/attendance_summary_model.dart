import 'package:flutter/material.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/theme.dart';

class AttendanceSummaryModel {
  final String icon;
  final String title;
  final String? count;
  final Color color;

  AttendanceSummaryModel(
      {required this.icon,
      required this.title,
      required this.count,
      required this.color});
}

List<AttendanceSummaryModel> attendanceSummaryModelList(
        {required AttendanceController attendanceController}) =>
    [
      AttendanceSummaryModel(
          icon: Assets.svgsPunchIn,
          title: "Present",
          count: attendanceController.employeesAttendanceSummaryModel?.punchOut
                  .toString() ??
              "",
          color: greenDark1),
      AttendanceSummaryModel(
          icon: Assets.svgsAbsent,
          title: "Absent",
          count: attendanceController.employeesAttendanceSummaryModel?.absent
                  .toString() ??
              "",
          color: red1),
      AttendanceSummaryModel(
          icon: Assets.svgsLeave,
          title: "Leave",
          count: attendanceController.employeesAttendanceSummaryModel?.leave
                  .toString() ??
              "",
          color: blueLight3),
      // AttendanceSummaryModel(
      //     icon: Icons.,
      //     title: "Leave",
      //     count: "8",
      //     color: yellow),
      // AttendanceSummaryModel(
      //     icon: Icons.edit_calendar_outlined,
      //     title: "Leave",
      //     count: "2",
      //     color: primaryColor),
    ];
