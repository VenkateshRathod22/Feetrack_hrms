import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/attendance_list_section/attendance_list_section.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/attendance_summary_section/attendance_summary_section.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/select_month_widget.dart';
import 'package:vlr/views/screens/attendance/attendance_overide/attendence_override_screen.dart';
import 'package:vlr/views/screens/attendance/attendence_calender/attendence_calender_screen.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final attendanceController = Get.find<AttendanceController>();
      attendanceController.selectedMonth = getDateTime();
      attendanceController.fetchAttendanceHistory();
      attendanceController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 85.h,
        backgroundColor: primaryColor,
        leading: const AppBarBackButton(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: InkWell(
              onTap: () {
                navigate(context: context, page: const AttendenceOverrideScreen());
              },
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.history_edu_rounded, color: white, size: 22.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: InkWell(
              onTap: () {
                navigate(context: context, page: const AttendenceCalenderScreen());
              },
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calendar_month_rounded, color: white, size: 22.sp),
              ),
            ),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Attendance History",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 20,
                    color: white,
                  ),
            ),
            CustomText(
              "Track your attendance records",
              style: Helper(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: white,
                  ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(child: SelectMonthWidget()),
                  sizedBoxWidth(width: 12),
                  InkWell(
                    onTap: () => navigate(context: context, page: const AttendenceOverrideScreen()),
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: greyLight1),
                      ),
                      child: Icon(Icons.history_edu_rounded, color: primaryColor),
                    ),
                  ),
                  sizedBoxWidth(width: 12),
                  InkWell(
                    onTap: () => navigate(context: context, page: const AttendenceCalenderScreen()),
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: greyLight1),
                      ),
                      child: Icon(Icons.grid_view_rounded, color: primaryColor),
                    ),
                  ),
                  sizedBoxWidth(width: 12),
                  // InkWell(
                  //   onTap: () => navigate(context: context, page: const AttendenceOverrideScreen()),
                  //   child: Container(
                  //     padding: EdgeInsets.all(12.r),
                  //     decoration: BoxDecoration(
                  //       color: white,
                  //       borderRadius: BorderRadius.circular(12.r),
                  //       border: Border.all(color: greyLight1),
                  //     ),
                  //     child: Icon(Icons.history_edu_rounded, color: primaryColor),
                  //   ),
                  // ),
                  sizedBoxWidth(width: 12),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        final attendanceController = Get.find<AttendanceController>();
                        attendanceController.selectedDate = picked;
                        String formattedDate = DateFormatters().yMD.format(picked);
                        attendanceController.fetchAttendanceHistory(date: formattedDate);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: greyLight1),
                      ),
                      child: Icon(Icons.calendar_month, color: primaryColor),
                    ),
                  ),
                ],
              ),
              sizedBoxHeight(height: 24.h),
              const AttendanceSummarySection(),
              sizedBoxHeight(height: 24.h),
              const AttendanceListSection()
            ],
          ),
        ),
      ),
    );
  }
}
