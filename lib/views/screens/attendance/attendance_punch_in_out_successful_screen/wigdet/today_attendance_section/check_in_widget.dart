import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/today_attendance_section/today_in_widget_model.dart';

class CheckInWidget extends StatelessWidget {
  final TodayInWidgetModel todayInWidgetModel;
  const CheckInWidget({
    super.key,
    required this.todayInWidgetModel,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: todayInWidgetModel.color.withValues(alpha: 0.10),
            ),
            child: Icon(
              todayInWidgetModel.icon,
              color: todayInWidgetModel.color,
            ),
          ),
          sizedBoxHeight(height: 4.h),
          CustomText(
            todayInWidgetModel.title,
            maxLines: 2,
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 10.sp,
                  color: black,
                ),
          ),
          sizedBoxHeight(height: 4.h),
          todayInWidgetModel.widget
        ],
      );
    });
  }
}
