import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/today_attendance_section/check_in_widget.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/today_attendance_section/today_in_widget_model.dart';

class TodayAttendanceSection extends StatelessWidget {
  const TodayAttendanceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
            color: black.withValues(
              alpha: 0.05,
            ),
          ),
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
            color: black.withValues(
              alpha: 0.05,
            ),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.watch_later_outlined,
                size: 18.sp,
                color: primaryColor,
              ),
              sizedBoxWidth(width: 8.w),
              Expanded(
                child: CustomText(
                  "Today's Attendance",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: blackText1,
                      ),
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 16.h),
          SizedBox(
            height: 100.h,
            child: GetBuilder<AttendanceController>(
              builder: (attendanceController) {
                final list = todayInWidgetModelList(
                  attendanceController: attendanceController,
                  context: context,
                );

                return Row(
                  children: List.generate(list.length * 2 - 1, (index) {
                    if (index.isOdd) {
                      return Container(
                        width: 1,
                        color: greyLight6,
                      );
                    }

                    final item = list[index ~/ 2];

                    return Expanded(
                      child: CheckInWidget(
                        todayInWidgetModel: item,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
