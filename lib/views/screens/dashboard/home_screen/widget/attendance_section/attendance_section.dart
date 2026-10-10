import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/permission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/attendance_camera_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/check_in_out_row_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/duty_status_widget.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/location_row_widget.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/working_time_section.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: containerDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                "Today’s Attendance",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18.sp,
                    ),
              ),
            ],
          ),
          sizedBoxHeight(height: 20.h),
          const AttendanceCameraSection(),
          sizedBoxHeight(height: 16.h),
          const DutyStatusWidget(),
          sizedBoxHeight(height: 8.h),
          const LocationRowWidget(),
          sizedBoxHeight(height: 12.h),
          const WorkingTimeSection(),
          sizedBoxHeight(height: 12.h),
          const CheckInAndOutTImeRowSection(),
          sizedBoxHeight(height: 20.h),
          GetBuilder<PermissionController>(builder: (permissionController) {
            return Row(
              children: [
                Expanded(
                  child: CustomButton(
                    height: 50.h,
                    radius: 12.r,
                    onTap: () {
                      permissionController.updateCamera(value: true);
                    },
                    type: ButtonType.secondary,
                    borderColor: grey1,
                    child: CustomText(
                      "Check in",
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16.sp,
                          ),
                    ),
                  ),
                ),
                sizedBoxWidth(width: 12),
                Expanded(
                  child: CustomButton(
                    height: 50.h,
                    radius: 12.r,
                    onTap: () {
                      permissionController.updateCamera(value: false);
                    },
                    color: primaryColor,
                    borderColor: primaryColor,
                    child: CustomText(
                      "Check out",
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16.sp,
                            color: Get.isDarkMode ? black : white,
                          ),
                    ),
                  ),
                ),
              ],
            );
          })
        ],
      ),
    );
  }
}
