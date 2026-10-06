import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/controllers/permission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/attendance_mart_screen/widget/capture_vetification_section.dart';
import 'package:vlr/views/screens/attendance/attendance_mart_screen/widget/check_list_section/check_list_section.dart';
import 'package:vlr/views/screens/attendance/attendance_mart_screen/widget/today_status_section/today_status_section.dart';

class AttendanceMartScreen extends StatefulWidget {
  const AttendanceMartScreen({super.key});

  @override
  State<AttendanceMartScreen> createState() => _AttendanceMartScreenState();
}

class _AttendanceMartScreenState extends State<AttendanceMartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final PermissionController permissionController =
          Get.find<PermissionController>();
      permissionController.clearSelfie();
      permissionController.clearLocation();

      await permissionController.requestLocationPermissionAndFetch(context);

      Get.find<AttendanceController>().fetchCheckListPoint();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          "Attendance",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 24.sp,
              ),
        ),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Mark Attendance",
              style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 28.sp,
                    color: blackText3,
                  ),
            ),
            CustomText(
              "Capture your selfie and GPS location to Punch In/out.",
              style: Helper(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    color: greyDart2,
                  ),
            ),
            sizedBoxHeight(height: 24.h),
            const TodayStatus(),
            sizedBoxHeight(height: 24.h),
            const CaptureVerificationSection(),
            sizedBoxHeight(height: 24.h),
            const CheckListSection(),
          ],
        ),
      ),
    );
  }
}
