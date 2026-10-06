import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/attendance_list_section/attendance_list_section.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/employee_attendance_history_screen/widget/appbar_of_employee_section/appbar_of_employee_section.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/employee_attendance_history_screen/widget/attendance_of_attendance_heading.dart';

class EmployeeAttendanceHistoryScreen extends StatefulWidget {
  const EmployeeAttendanceHistoryScreen({super.key});

  @override
  State<EmployeeAttendanceHistoryScreen> createState() =>
      _EmployeeAttendanceHistoryScreenState();
}

class _EmployeeAttendanceHistoryScreenState
    extends State<EmployeeAttendanceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final attendanceController = Get.find<AttendanceController>();
      attendanceController.selectedMonth = getDateTime();
      attendanceController.fetchTeamEmployeeAttendanceList();
      attendanceController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarOfEmployeeSection(),
          sizedBoxHeight(height: 20.h),
          const RowOfAttendanceHeading(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const AttendanceListSection(),
            ),
          )
        ],
      ),
    );
  }
}
