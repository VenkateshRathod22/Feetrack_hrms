import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/attendance_summary_section/attendance_summary_model.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/attendance_summary_section/attendance_summary_widget.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/this_month_target_section/half_circle_progress.dart';

class AttendanceSummarySection extends StatelessWidget {
  const AttendanceSummarySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      final now = DateTime.now();
      final selected = attendanceController.selectedMonth;

      final isCurrentMonth =
          selected.year == now.year && selected.month == now.month;
      final list = attendanceSummaryModelList(
          attendanceController: attendanceController);

      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 30.r,
              color: black.withValues(alpha: 0.04),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Header Section ---
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.analytics_outlined, color: primaryColor, size: 20.sp),
                ),
                sizedBoxWidth(width: 12.w),
                Expanded(
                  child: CustomText(
                    "Overview",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: blackText1,
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.r),
                    color: greyLight1,
                    border: Border.all(color: greyLight6, width: 0.5),
                  ),
                  child: CustomText(
                    isCurrentMonth
                        ? "This Month"
                        : DateFormat('MMMM yyyy').format(selected),
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: tertiaryColor,
                        ),
                  ),
                )
              ],
            ),
            
            sizedBoxHeight(height: 24.h),

            /// --- Hour Stats Section (Cards) ---
            if (attendanceController.employeesAttendanceSummaryModel?.totalHours != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildHourStatCard(
                      context, 
                      "Total Hours", 
                      attendanceController.employeesAttendanceSummaryModel!.totalHours!, 
                      const Color(0xFF3B82F6), // Blue
                      Icons.timer_outlined,
                    ),
                  ),
                  sizedBoxWidth(width: 12.w),
                  Expanded(
                    child: _buildHourStatCard(
                      context, 
                      "Productive", 
                      attendanceController.employeesAttendanceSummaryModel!.productiveHours!, 
                      const Color(0xFF10B981), // Green
                      Icons.trending_up_rounded,
                    ),
                  ),
                  sizedBoxWidth(width: 12.w),
                  Expanded(
                    child: _buildHourStatCard(
                      context, 
                      "Overtime", 
                      attendanceController.employeesAttendanceSummaryModel!.overtimeHours!, 
                      const Color(0xFFF59E0B), // Orange
                      Icons.more_time_rounded,
                    ),
                  ),
                ],
              ),
              sizedBoxHeight(height: 24.h),
              Divider(color: greyLight6.withValues(alpha: 0.5), thickness: 1),
              sizedBoxHeight(height: 16.h),
            ],

            /// --- Bottom Stats Section (Counts & Progress) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: list.map((item) {
                      return Expanded(
                        child: AttendanceSummaryWidget(
                          attendanceSummaryModel: item,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                Container(
                  height: 60.h,
                  width: 1,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  color: greyLight6,
                ),

                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      CustomText(
                        "Attendance",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: greyDart2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      sizedBoxHeight(height: 8.h),
                      SizedBox(
                        height: 70.h,
                        child: HalfCircleProgress(
                          percent: attendanceController.attendancePer,
                          progressColor: tertiaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _buildHourStatCard(BuildContext context, String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18.sp),
          sizedBoxHeight(height: 8.h),
          CustomText(
            value,
            style: TextStyle(
              fontSize: 15.sp, 
              fontWeight: FontWeight.w800, 
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          sizedBoxHeight(height: 2.h),
          CustomText(
            label,
            style: TextStyle(
              fontSize: 9.sp, 
              color: greyDart2, 
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
