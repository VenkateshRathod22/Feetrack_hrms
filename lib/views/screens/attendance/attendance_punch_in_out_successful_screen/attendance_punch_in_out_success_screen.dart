import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/attendance/attendacn_details/widget/checklist_responses_section/checklist_respones.dart';
import 'package:vlr/views/screens/attendance/attendance_history/attendance_history_screen.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/location_details_section/location_details_section.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/today_attendance_section/check_out_selfe_section.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/today_attendance_section/today_attendance_section.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/top_section_attendance_punch_out.dart';
import 'package:vlr/views/screens/dashboard/dashboard_screen.dart';

class AttendancePunchInOutSuccessScreen extends StatefulWidget {
  const AttendancePunchInOutSuccessScreen({super.key});

  @override
  State<AttendancePunchInOutSuccessScreen> createState() =>
      _AttendancePunchInOutSuccessScreenState();
}

class _AttendancePunchInOutSuccessScreenState
    extends State<AttendancePunchInOutSuccessScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Get.find<AttendanceController>().loadDemoAttendancePunchOut();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: white,
            )),
        centerTitle: true,
        title:
            GetBuilder<AttendanceController>(builder: (attendanceController) {
          return CustomText(
            (attendanceController.attendanceModel?.isPunchIn ?? false)
                ? "Punch In Successful"
                : (attendanceController.attendanceModel?.isPunchIn ?? false)
                    ? "Punch Out Successful"
                    : "",
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16.sp,
                  color: white,
                ),
          );
        }),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            const TopSectionAttendancePunchOutSection(),
            sizedBoxHeight(height: 26.h),
            const CheckOutSelfeSection(),
            sizedBoxHeight(height: 26.h),
            const TodayAttendanceSection(),
            sizedBoxHeight(height: 26.h),
            const ChecklistResponsesSection(),
            sizedBoxHeight(height: 26.h),
            const LocationDetailSection(),
            sizedBoxHeight(height: 26.h),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  height: 56.h,
                  radius: 12.r,
                  onTap: () {
                    navigate(
                        context: context,
                        page: const AttendanceHistoryScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        color: white,
                      ),
                      sizedBoxWidth(width: 8.w),
                      CustomText(
                        "View Attendance History",
                        style: Helper(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp,
                              color: white,
                            ),
                      ),
                    ],
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomButton(
                  height: 56.h,
                  radius: 12.r,
                  onTap: () {
                    navigate(context: context, page: const DashboardScreen());
                  },
                  type: ButtonType.secondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(
                        Icons.home_outlined,
                        color: primaryColor,
                      ),
                      sizedBoxWidth(width: 8.w),
                      CustomText(
                        "Back to Home",
                        style: Helper(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp,
                              color: primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
