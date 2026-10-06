import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/attendance/attendance_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/attendacn_details/attendance_details_screen.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/attendance_list_section/attendance_widget.dart';

import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/attendance/attendance_history/widget/attendance_list_section/attendance_history_table.dart';

import '../../../../../../services/custom_text.dart';
import '../../../../../../services/theme.dart';

class AttendanceListSection extends StatefulWidget {
  const AttendanceListSection({super.key});

  @override
  State<AttendanceListSection> createState() => _AttendanceListSectionState();
}

class _AttendanceListSectionState extends State<AttendanceListSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(
      builder: (attendanceController) {
        if (attendanceController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3,
            ),
          );
        }

        if (attendanceController.attendanceList.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 120.r,
                        width: 120.r,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.03),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        height: 90.r,
                        width: 90.r,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Icon(
                        Icons.history_toggle_off_rounded,
                        size: 50.sp,
                        color: primaryColor.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                  sizedBoxHeight(height: 24),
                  CustomText(
                    "No Logs Yet",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: blackText1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  sizedBoxHeight(height: 10),
                  CustomText(
                    "It looks like there's no data for this period.\nTry selecting a different date from above.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: greyDart2,
                      height: 1.4,
                    ),
                  ),
                  sizedBoxHeight(height: 32),
                  CustomButton(
                    // width: 180.w,
                    height: 52.h,
                    radius: 16.r,
                    onTap: () => attendanceController.fetchAttendanceHistory(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh_rounded, color: white, size: 20.sp),
                        sizedBoxWidth(width: 8),
                        CustomText(
                          "Refresh Data",
                          style: TextStyle(color: white, fontWeight: FontWeight.w700, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, tertiaryColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  sizedBoxWidth(width: 12),
                  CustomText(
                    "Activity Log",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: blackText1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: greyLight6),
                    ),
                    child: CustomText(
                      "${attendanceController.attendanceList.length} Sessions",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: greyDart2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: AttendanceHistoryTable(
                  attendanceList: attendanceController.attendanceList,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
